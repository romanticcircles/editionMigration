<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no"/>
    <xsl:strip-space elements="*"/>

<xsl:template match="tei:TEI">
    <help>
    <xsl:apply-templates select="tei:teiHeader/tei:encodingDesc/tei:classDecl/tei:taxonomy[@xml:id = 'g']"/>
    <xsl:apply-templates select="tei:teiHeader/tei:encodingDesc/tei:classDecl/tei:taxonomy[@xml:id = 'f']"/>
    </help>
</xsl:template>
    
    <xsl:template match="tei:taxonomy[@xml:id='g']">
        <xsl:for-each select="tei:category">
            <xsl:variable name="idNbr" select="@xml:id"/>
            <xsl:text disable-output-escaping="yes">&lt;xsl:if test=". = '</xsl:text>
            <xsl:value-of select="concat('#', $idNbr)"/>
            <xsl:text disable-output-escaping="yes">'"&gt;&lt;xsl:text&gt;</xsl:text>
            <xsl:value-of select="tei:catDesc"/>
            <xsl:text disable-output-escaping="yes">&lt;/xsl:text&gt;&lt;/xsl:if&gt;</xsl:text>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="tei:taxonomy[@xml:id='f']">
        <xsl:for-each select="tei:category">
            <xsl:variable name="idNbr" select="@xml:id"/>
            <xsl:text disable-output-escaping="yes">&lt;xsl:if test=". = '</xsl:text>
            <xsl:value-of select="concat('#', $idNbr)"/>
            <xsl:text disable-output-escaping="yes">'"&gt;&lt;xsl:text&gt;</xsl:text>
            <xsl:value-of select="tei:catDesc"/>
            <xsl:text disable-output-escaping="yes">&lt;/xsl:text&gt;&lt;/xsl:if&gt;</xsl:text>
        </xsl:for-each>
    </xsl:template>
        
</xsl:stylesheet>