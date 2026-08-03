<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei" version="3.0">
    <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="no"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="peopleNamesDoc" as="document-node()" select="doc('../people_names.xml')"/>
    <xsl:key name="personLookup" match="*[local-name() = 'person']" use="@xml:id"/>

    <xsl:template match="/">
        <mentions>
        <xsl:apply-templates/>
        </mentions>
    </xsl:template>
    
    <xsl:template match="list">
        <xsl:for-each select="item">
                <xsl:apply-templates select="document(@code)/tei:TEI"/>
        </xsl:for-each>
    </xsl:template>

   <xsl:template match="tei:TEI">
       <xsl:variable name="docID"
           select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition']"/>
       <xsl:variable name="getPath">
           <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:editionStmt/tei:edition/@n"/>
       </xsl:variable>
       <xsl:variable name="ptPath">
           <xsl:choose>
               <xsl:when test="$getPath = ''">paratext</xsl:when>
               <xsl:when test="$getPath = '1'">Part_One</xsl:when>
               <xsl:when test="$getPath = '2'">Part_Two</xsl:when>
               <xsl:when test="$getPath = '3'">Part_Three</xsl:when>
               <xsl:when test="$getPath = '4'">Part_Four</xsl:when>
               <xsl:when test="$getPath = '5'">Part_Five</xsl:when>
               <xsl:when test="$getPath = '6'">Part_Six</xsl:when>
               <xsl:when test="$getPath = '7'">Part_Seven</xsl:when>
           </xsl:choose>
       </xsl:variable>
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
           <xsl:for-each select="//tei:ref[@type = 'm']">
               <xsl:variable name="persID" select="substring-after(@target, 'people.html#')"/>
               <name id="{$persID}"><xsl:value-of select="key('personLookup', $persID, $peopleNamesDoc)"/></name>
               <letter id="{$docID}"><xsl:value-of select="concat('Letter ', substring-after($docID, 'southey.'), ', ', normalize-space($letDateLabel))"/>                 
               </letter>
           </xsl:for-each>
   </xsl:template>
    
</xsl:stylesheet>
