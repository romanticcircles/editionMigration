<?xml version="1.0" encoding="UTF-8"?>
<!--from gemini pro-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"  exclude-result-prefixes="tei">
    <xsl:output method="text" indent="yes"/>
    
    <!-- Define a key to group elements by their name, restricted to the target element -->
    <xsl:key name="distinct-elements" match="node()" use="name()" />
    
    <xsl:template match="/">
        <!-- Find all elements, but filter for the first occurrence of each name -->
        <xsl:for-each select="//node()[generate-id() = generate-id(key('distinct-elements', name())[1])]">
            <xsl:value-of select="name()"/>
            <xsl:text>&#xa;</xsl:text> <!-- Outputs a newline after each name -->
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>