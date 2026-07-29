<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei" version="2.0">
    <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no"/>
    <xsl:strip-space elements="*"/>


    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="list">
        <xsl:for-each select="item">
            <xsl:result-document href="new/{@code}">
            <xsl:apply-templates select="document(@code)/tei:TEI"/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:publicationStmt/tei:availability"/>
    
    <xsl:template match="tei:textClass">
            <xsl:copy>
                <xsl:for-each-group select="tei:catRef" group-by="@target">
                    <xsl:copy-of select="."/>
                </xsl:for-each-group>
            </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:revisionDesc">
        <revisionDesc xmlns="http://www.tei-c.org/ns/1.0">
        <change when="2026-07-25" who="#LM">
            <label>Changed by</label><name>Laura Mandell</name>
            <list>
                <item>Corrected XML files</item>
            </list>
        </change>
        <xsl:copy-of select="tei:change"/>
        </revisionDesc>
    </xsl:template>
    
</xsl:stylesheet>
