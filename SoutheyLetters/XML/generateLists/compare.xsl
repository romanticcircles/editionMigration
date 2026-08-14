<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="tei xs">
    
    <!-- run using the CHECKall.xml file -->
    
    <!-- Output as plain text -->
    <xsl:output method="text" encoding="UTF-8"/>
    
    <!-- Load external corresp.xml document -->
    <xsl:variable name="corresp-doc" select="doc('paratext/corresp.xml')"/>
    
    <xsl:template match="/corresp">
        <!-- 1. Extract sequence of IDs from current document (CHECKall.xml) -->
        <xsl:variable name="checkall-ids" select="name/@id"/>
        
        <!-- 2. Extract sequence of IDs from TEI corresp.xml -->
        <xsl:variable name="corresp-ids" select="
            for $ref in $corresp-doc//tei:item/tei:ref/@target
            return substring-after($ref, '#')"/>
        
        <!-- SECTION 1: IDs in CHECKall.xml but NOT in corresp.xml -->
        <xsl:text>==================================================&#10;</xsl:text>
        <xsl:text>NAMES ONLY IN CHECKall.xml (Missing from corresp.xml)&#10;</xsl:text>
        <xsl:text>==================================================&#10;</xsl:text>
        <xsl:variable name="only-in-checkall" select="name[not(@id = $corresp-ids)]"/>
        <xsl:choose>
            <xsl:when test="exists($only-in-checkall)">
                <xsl:for-each select="$only-in-checkall">
                    <xsl:value-of select="concat(@id, ' - ', .)"/>
                    <xsl:text>&#10;</xsl:text>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>[None]&#10;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        
        <xsl:text>&#10;&#10;</xsl:text>
        
        <!-- SECTION 2: IDs in corresp.xml but NOT in CHECKall.xml -->
        <xsl:text>==================================================&#10;</xsl:text>
        <xsl:text>NAMES ONLY IN corresp.xml (Missing from CHECKall.xml)&#10;</xsl:text>
        <xsl:text>==================================================&#10;</xsl:text>
        <xsl:variable name="only-in-corresp" select="
            $corresp-doc//tei:item/tei:ref[not(substring-after(@target, '#') = $checkall-ids)]"/>
        <xsl:choose>
            <xsl:when test="exists($only-in-corresp)">
                <xsl:for-each select="$only-in-corresp">
                    <xsl:value-of select="concat(substring-after(@target, '#'), ' - ', .)"/>
                    <xsl:text>&#10;</xsl:text>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>[None]&#10;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
</xsl:stylesheet>