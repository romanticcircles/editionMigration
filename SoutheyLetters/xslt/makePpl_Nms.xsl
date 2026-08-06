<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei" version="3.0">
    <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:TEI">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:teiHeader"/>

    <xsl:template match="tei:text">
        <xsl:apply-templates select="tei:body/tei:div/tei:listPerson"/>
    </xsl:template>

    <xsl:template match="tei:listPerson">
        <names>
        <xsl:for-each select="tei:person">
                <xsl:apply-templates select="tei:persName"/>
        </xsl:for-each>
        </names>
    </xsl:template>

    <xsl:template match="tei:persName">
        <person xml:id="{@xml:id}">
            <xsl:choose>
                <xsl:when test="tei:surname[@type = 'dynasty']">
                    <xsl:value-of select="tei:forename"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="tei:roleName"/>
                </xsl:when>
                <xsl:when test="tei:surname[2]">
                    <xsl:choose>
                        <xsl:when test="tei:surname[@type = 'birth']">
                            <xsl:value-of select="tei:surname[@type = 'married']"/>
                            <xsl:text>, </xsl:text>
                            <xsl:value-of select="tei:forename"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="tei:surname[@type = 'birth']"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="tei:surname"/>
                    <xsl:choose>
                        <xsl:when test="tei:forename = 'Family'">
                            <xsl:text> </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>, </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="tei:forename">
                            <xsl:value-of select="tei:forename"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="tei:roleName"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </person>
    </xsl:template>


</xsl:stylesheet>
