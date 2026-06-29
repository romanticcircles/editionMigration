<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="3.0">
    <xsl:output method="text" encoding="utf-8" omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="TEI">
        <xsl:apply-templates select="text"/>
    </xsl:template>
    
    <xsl:template match="p | note | q | l | lb | lg">
                <xsl:text> </xsl:text>
                <xsl:apply-templates/>
                <xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:value-of select="tokenize(normalize-space(.), '\s+')"/>
    </xsl:template>
    
</xsl:stylesheet>