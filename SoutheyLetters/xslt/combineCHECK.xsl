<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs">
    
    <!-- run this xslt on the combineCHECK.xml file -->
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <!-- Match the root of the file list XML -->
    <xsl:template match="/list">
        <!-- Load all external XML documents referenced in the item/@code attributes -->
        <xsl:variable name="all-docs" select="for $item in item/@code return doc($item)"/>
        
        <corresp>
            <!-- Group all <name> elements across all documents by their @id attribute -->
            <xsl:for-each-group select="$all-docs//name[@id]" group-by="@id">
                <!-- Sort groups alphabetically by the @id value -->
                <xsl:sort select="current-grouping-key()"/>
                
                <!-- Output the first unique <name> element instance in full -->
                <xsl:copy-of select="current-group()[1]"/>
            </xsl:for-each-group>
        </corresp>
    </xsl:template>
    
</xsl:stylesheet>