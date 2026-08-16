import xml.etree.ElementTree as ET
import pandas as pd
import networkx as nx

def xml_to_gephi_csv(xml_file_path, nodes_output_path, edges_output_path):
    # Load and parse the XML file
    tree = ET.parse(xml_file_path)
    root = tree.getroot()
    
    nodes_dict = {}
    edges_list = []
    
    # Process each relationship entity
    for addressee in root.findall('addressee'):
        name_el = addressee.find('name')
        ref_el = addressee.find('ref')
        
        if name_el is not None and ref_el is not None:
            source_id = name_el.attrib.get('id')
            source_label = name_el.text.strip() if name_el.text else source_id
            
            target_id = ref_el.attrib.get('id')
            target_label = ref_el.text.strip() if ref_el.text else target_id
            
            # Map clean unique ID strings to readable text Labels
            if source_id not in nodes_dict:
                nodes_dict[source_id] = source_label
            if target_id not in nodes_dict:
                nodes_dict[target_id] = target_label
                
            edges_list.append((source_id, target_id))
            
    # Compile a Directed Graph via NetworkX to compute explicit structural weight values
    G = nx.DiGraph()
    for src, tgt in edges_list:
        if G.has_edge(src, tgt):
            G[src][tgt]['weight'] += 1
        else:
            G.add_edge(src, tgt, weight=1)
            
    # Format Edges DataFrame to match Gephi targets
    edges_df = nx.to_pandas_edgelist(G)
    edges_df.rename(columns={'source': 'Source', 'target': 'Target', 'weight': 'Weight'}, inplace=True)
    edges_df['Type'] = 'Directed'
    
    # Format Nodes DataFrame to match Gephi targets
    nodes_df = pd.DataFrame(list(nodes_dict.items()), columns=['ID', 'Label'])
    
    # Save files out
    nodes_df.to_csv(nodes_output_path, index=False)
    edges_df.to_csv(edges_output_path, index=False)
    print(f"Success! Saved {len(nodes_df)} nodes and {len(edges_df)} unique weighted edges.")
