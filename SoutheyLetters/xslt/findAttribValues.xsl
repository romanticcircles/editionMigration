<?xml version="1.0" encoding="UTF-8"?>
<!--from gemini pro-->
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"  exclude-result-prefixes="tei">
    <xsl:output method="text" indent="yes"/>
    
    <xsl:template match="/">
        <!-- Group by name first so the output stays organized by attribute -->
        <xsl:for-each-group select="//tei:hi/@*" group-by="name()">
            <!-- Then, within that attribute, group by its unique values -->
            <xsl:for-each-group select="current-group()" group-by=".">
                <xsl:value-of select="name()"/>
                <xsl:text> = </xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>&#xa;</xsl:text>
            </xsl:for-each-group>
        </xsl:for-each-group>
    </xsl:template>
    
</xsl:stylesheet>