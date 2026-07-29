<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei" version="3.0">
    
    <xsl:output method="text" omit-xml-declaration="yes" indent="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="list">
        <xsl:for-each select="item">
            <xsl:apply-templates select="document(@code)/tei:TEI"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <xsl:apply-templates select="tei:teiHeader"/>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader">
        <xsl:value-of select="tei:fileDesc/tei:publicationStmt/tei:idno"/>
        <xsl:text>,</xsl:text>
        <xsl:value-of select="count(tei:fileDesc/tei:sourceDesc/tei:p)"/>
        <xsl:text>
        </xsl:text>
    </xsl:template>
    
</xsl:stylesheet>