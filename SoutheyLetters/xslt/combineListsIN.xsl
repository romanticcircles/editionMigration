<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs">
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <!-- Match the root of the file list XML (e.g. list.xml) -->
    <xsl:template match="/list">
        <!-- Load all external XML documents referenced in the <item/@code> attributes -->
        <xsl:variable name="all-docs" select="for $item in item/@code return doc($item)"/>
        
        <mentions>
            <!-- Group all <to> elements across all documents by the @id of their <name> child -->
            <xsl:for-each-group select="$all-docs//mentions/mentioned" group-by="name/@id">
                <!-- Sort groups alphabetically by name id -->
                <xsl:sort select="current-grouping-key()"/>
                <person>
                    <!-- Output the name element once (takes the first instance found) -->
                    <xsl:copy-of select="name"/>
                    
                    <!-- Collect all <letter> elements for this person across all files -->
                    <xsl:for-each select="current-group()/letter">
                        <!-- Sort letters by letter ID to keep them in order -->
                        <xsl:sort select="@id"/>
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </person>
            </xsl:for-each-group>
        </mentions>
    </xsl:template>
    
</xsl:stylesheet>
