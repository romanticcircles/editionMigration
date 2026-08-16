<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei" version="3.0">
    
    <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="peopleNamesDoc" as="document-node()" select="doc('../people_names.xml')"/>
    <xsl:key name="personLookup" match="*[local-name() = 'person']" use="@xml:id"/>
    
    <xsl:template match="/">
        <corresp>
            <xsl:apply-templates/>
        </corresp>
    </xsl:template>
    
    <xsl:template match="list">
        <xsl:for-each select="item">
            <xsl:apply-templates select="document(@code)/tei:TEI"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <xsl:variable name="docID"
            select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition']"/>
        <xsl:variable name="letDateLabel">
            <xsl:choose>
                <xsl:when test="//tei:div[@type = 'letter'][1]/tei:head/tei:date/tei:choice">
                    <xsl:value-of
                        select="//tei:div[@type = 'letter'][1]/tei:head/tei:date/tei:choice/tei:corr/tei:date"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="//tei:div[@type = 'letter'][1]/tei:head/tei:date"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!-- Process each <ref type="a"> element individually -->
        <xsl:for-each select="//tei:ref[@type = 'a']">
            <xsl:variable name="target" select="@target"/>
            
            <!-- Extract ID and target type based on URL pattern -->
            <xsl:variable name="personID" select="substring-after($target, 'people.html#')"/>
            <xsl:variable name="unknown" select="substring-after($target, 'corresp.html#')"/>
            
            <to>
                <xsl:choose>
                    <!-- Handle standard people links -->
                    <xsl:when test="$personID != ''">
                        <xsl:variable name="personName" select="key('personLookup', $personID, $peopleNamesDoc)"/>
                        <name id="{$personID}">
                            <xsl:value-of select="$personName"/>
                        </name>
                    </xsl:when>
                    
                    <!-- Handle unknown/correspondence links -->
                    <xsl:when test="$unknown != ''">
                        <name id="{$unknown}">[Unknown Correspondent]</name>
                    </xsl:when>
                    
                    <!-- Fallback for other format variations -->
                    <xsl:otherwise>
                        <name id="unknown">[Unknown Correspondent]</name>
                    </xsl:otherwise>
                </xsl:choose>
                
                <letter id="{$docID}">
                    <xsl:value-of select="concat('Letter ', substring-after($docID, 'southey.'), ', ', normalize-space($letDateLabel))"/>                 
                </letter>
            </to>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>