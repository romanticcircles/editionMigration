<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="xs tei" version="2.0">
   
   <!-- run this xslt on each of the 25 main witness xml files to separate them into items
      inside a folder named by witness id and generate a list that can then be run using 
      toWebLBsingle.xsl which will create individual item web pages inside a subfolder of
      HTML; the subfolder has the witness id as title. -->

   <xsl:output method="xml" indent="yes" encoding="UTF-8" omit-xml-declaration="no"/>
   <xsl:strip-space elements="*"/>
   
   <xsl:param name="edID" select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='local']"/>
   
   <xsl:template match="/">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="@* | node()">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="tei:TEI">
      <xsl:variable name="frontURL" select="concat($edID, '_', tei:text/tei:front/@xml:id, '.xml')"/>
      <xsl:result-document href="{$edID}/{$frontURL}">
         <TEI xmlns="http://www.tei-c.org/ns/1.0">
         <xsl:apply-templates select="tei:teiHeader"/>
            <text>
         <xsl:apply-templates select="tei:text/tei:front"/>
            <body><p>&#160;</p></body>
            </text>
         </TEI>
      </xsl:result-document>
      <xsl:apply-templates select="tei:text/tei:group"/>
      <xsl:result-document href="{$edID}/{$edID}_list.xml">
         <list id="{$edID}">
            <item>
               <xsl:attribute name="code">
                  <xsl:value-of select="$frontURL"/>
               </xsl:attribute>
            </item>
            <xsl:for-each select="tei:text/tei:group/tei:text">
               <xsl:if test="tei:front">
               <item>
                  <xsl:attribute name="code"><xsl:value-of select="concat($edID, '_', tei:front/@xml:id, '.xml')"/>
                  </xsl:attribute>
               </item>
               </xsl:if>
               <item>
                  <xsl:attribute name="code">
                     <xsl:value-of select="concat($edID, '_', tei:body/@xml:id, '.xml')"/>
                  </xsl:attribute>
               </item>
            </xsl:for-each>
         </list>
      </xsl:result-document>
   </xsl:template>

   <xsl:template match="tei:TEI/tei:text/tei:group">
      <xsl:for-each select="tei:text">
         <xsl:variable name="frontID" select="tei:front/@xml:id"/>
         <xsl:variable name="poemID" select="tei:body/@xml:id"/>
         <xsl:variable name="url">
            <xsl:value-of select="concat($edID, '_', $poemID, '.xml')"/>
         </xsl:variable>
         <xsl:variable name="urlF">
            <xsl:value-of select="concat($edID, '_', $frontID, '.xml')"/>
         </xsl:variable>
         <xsl:if test="tei:front">
               <xsl:result-document href="{$edID}/{$urlF}">
                  <TEI xmlns="http://www.tei-c.org/ns/1.0">
                     <xsl:apply-templates select="tei:front"/>
                  </TEI>
               </xsl:result-document>
            </xsl:if>
               <xsl:result-document href="{$edID}/{$url}">
                  <TEI xmlns="http://www.tei-c.org/ns/1.0">
                     <xsl:apply-templates select="tei:body"/>
                  </TEI>
               </xsl:result-document>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template match="tei:TEI/tei:text/tei:group/tei:text/tei:front" mode="attached">
      <front xmlns="http://www.tei-c.org/ns/1.0"><xsl:apply-templates/></front>
   </xsl:template>
   
   
   <xsl:template match="tei:TEI/tei:text/tei:group/tei:text/tei:front">
         <xsl:variable name="pubDate">
            <xsl:choose>
               <xsl:when test="$edID = 'lbphil-2'">1802</xsl:when>
               <xsl:when test="substring-after($edID, '-') = 'campbell'">1802</xsl:when>
               <xsl:when test="starts-with($edID, 'lb')">1798</xsl:when>
               <xsl:when test="substring($edID, 3, 2) = '98'">1798</xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="concat('18', substring($edID, 3, 2))"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <xsl:variable name="frontID" select="@xml:id"/>
         <xsl:variable name="ID">
            <xsl:value-of select="concat($edID, '_', $frontID)"/>
         </xsl:variable>
         <teiHeader xmlns="http://www.tei-c.org/ns/1.0">
            <fileDesc>
               <titleStmt>
                  <title>Lyrical Ballads, <xsl:value-of select="$pubDate"/>:<xsl:text> </xsl:text>
                     <xsl:value-of select="document('poemID.xml')/list/item[@code = $frontID]"/>
                  </title>
                  <editor>
                     <name xml:id="BG">Bruce Graver</name>
                  </editor>
                  <editor>
                     <name xml:id="RT">Ronald Tetreault</name>
                  </editor>
                  <respStmt>
                     <resp>Technical Editor; Producer</resp>
                     <name xml:id="LM">Laura Mandell</name>
                  </respStmt>
               </titleStmt>
               <publicationStmt>
                  <publisher>Romantic Circles</publisher>
                  <idno type="local">
                     <xsl:value-of select="$ID"/>
                  </idno>
               </publicationStmt>
               <sourceDesc>
                  <biblStruct>
                     <monogr xml:id="{$edID}">
                        <ptr>
                           <xsl:attribute name="target">
                              <xsl:value-of select="concat('../XML/', $edID, '.xml')"/>
                           </xsl:attribute>
                        </ptr>
                        <imprint>
                           <publisher>
                              <xsl:choose>
                                 <xsl:when test="$edID = 'LB98-L'">
                                    <xsl:text>J. &amp; A. Arch</xsl:text>
                                 </xsl:when>
                                 <xsl:when test="contains($edID, '98')">
                                    <xsl:text>[Cottle printing, London publisher not yet found]; title page reads
                                       T. N. Longman</xsl:text>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:text>T. N. Longman and O. Rees</xsl:text>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </publisher>
                           <pubPlace>
                              <xsl:choose>
                                 <xsl:when test="$edID = 'lbphil-2'">Philadelphia</xsl:when>
                                 <xsl:when test="substring-after($edID, '-') = 'campbell'">Philadelphia</xsl:when>
                                 <xsl:when test="substring-after($edID, '-') = 'B'">Bristol</xsl:when>
                                 <xsl:when test="substring-after($edID, '-') = 'b'">Bristol</xsl:when>
                                 <xsl:when test="substring-after($edID, '-') = 'L'">London</xsl:when>
                                 <xsl:when test="substring-after($edID, '-') = 'l'">London</xsl:when>
                              </xsl:choose>
                           </pubPlace>
                           <date>
                              <xsl:value-of select="$pubDate"/>
                           </date>
                        </imprint>
                        <biblScope unit="page">
                           <!-- getting first page -->
                                 <xsl:choose>
                                    <xsl:when test="*[2] = tei:milestone[@unit='page']">
                                       <xsl:value-of select="tei:milestone[@unit='page'][1]/@n"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:if test="*[1] = tei:pb and tei:pb[1]/@n != ''">
                                          <xsl:value-of select="tei:pb[1]/@n"/>
                                       </xsl:if>
                                    </xsl:otherwise>
                           </xsl:choose>
                           <!-- getting last page number -->
                           <xsl:choose>
                                    <xsl:when test="descendant-or-self::tei:milestone[@unit='page']/position() = 2">
                                       <xsl:value-of select="concat(' to ', descendant-or-self::tei:milestone[@unit='page'][last()]/@n)"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:if test="descendant-or-self::tei:pb[2] and descendant-or-self::tei:pb/@n !=''">
                                          <xsl:value-of select="concat(' to ', descendant-or-self::tei:pb[last()]/@n)"/>
                                       </xsl:if>
                                    </xsl:otherwise>
                                 </xsl:choose>
                        </biblScope>
                        <biblScope unit="pages">
                           <xsl:value-of select="count(descendant-or-self::tei:pb)"/>
                        </biblScope>
                     </monogr>
                  </biblStruct>
               </sourceDesc>
            </fileDesc>
            <revisionDesc>
               <change when="20250731" who="#LM">
                  Splurged out main xml into separate xml files for poems and paratexts.
               </change>
            </revisionDesc>
         </teiHeader>
         <text xmlns="http://www.tei-c.org/ns/1.0">
            <front><xsl:apply-templates/></front>
            <body><p>&#160;</p></body>
         </text>
   </xsl:template>
   
   <xsl:template match="tei:TEI/tei:text/tei:group/tei:text/tei:body">
      <xsl:variable name="pubDate">
         <xsl:choose>
            <xsl:when test="$edID = 'lbphil-2'">1802</xsl:when>
            <xsl:when test="substring-after($edID, '-') = 'campbell'">1802</xsl:when>
            <xsl:when test="starts-with($edID, 'lb')">1798</xsl:when>
            <xsl:when test="substring($edID, 3, 2) = '98'">1798</xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="concat('18', substring($edID, 3, 2))"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="poemID" select="@xml:id"/>
      <xsl:variable name="poemTitle">
         <xsl:value-of select="document('poemID.xml')/list/item[@code = $poemID]"/>
      </xsl:variable>
      <xsl:variable name="ID">
         <xsl:value-of select="concat($edID, '_', $poemID)"/>
      </xsl:variable>
      <teiHeader xmlns="http://www.tei-c.org/ns/1.0">
         <fileDesc>
            <titleStmt>
               <title>Lyrical Ballads, <xsl:value-of select="$pubDate"/>:<xsl:text> </xsl:text><xsl:value-of select="$poemTitle"/></title>
               <author>
                  <xsl:choose>
                     <xsl:when test="ends-with($poemID, 'stc')">
                        <name>Samuel Taylor Coleridge</name>
                     </xsl:when>
                     <xsl:when test="ends-with($poemID, 'tb')">
                        <name>Thomas Beddoes</name>
                     </xsl:when>
                     <xsl:otherwise>
                        <name>William Wordsworth</name>
                     </xsl:otherwise>
                  </xsl:choose>
               </author>
               <editor>
                  <name xml:id="BG">Bruce Graver</name>
               </editor>
               <editor>
                  <name xml:id="RT">Ronald Tetreault</name>
               </editor>
               <respStmt>
                  <resp>Technical Editor; Producer</resp>
                  <name xml:id="LM">Laura Mandell</name>
               </respStmt>
            </titleStmt>
            <publicationStmt>
               <publisher>Romantic Circles</publisher>
               <idno type="local">
                  <xsl:value-of select="$ID"/>
               </idno>
            </publicationStmt>
            <sourceDesc>
               <biblStruct>
                  <analytic xml:id="{$poemID}">
                     <title>
                        <xsl:value-of select="$poemTitle"/>
                     </title>
                     <author>
                        <xsl:choose>
                           <xsl:when test="ends-with($poemID, 'stc')">
                              <persName ref="http://viaf.org/viaf/24599809">Samuel Taylor Coleridge</persName>
                           </xsl:when>
                           <xsl:when test="ends-with($poemID, 'tb')">
                              <persName ref="http://viaf.org/viaf/64080402">Thomas Beddoes</persName>
                           </xsl:when>
                           <xsl:otherwise>
                              <persName ref="http://viaf.org/viaf/35723133">William Wordsworth</persName>
                           </xsl:otherwise>
                        </xsl:choose>
                     </author>
                  </analytic>
                  <monogr xml:id="{$edID}">
                     <ptr>
                        <xsl:attribute name="target">
                           <xsl:value-of select="concat('../XML/', $edID, '.xml')"/>
                        </xsl:attribute>
                     </ptr>
                     <imprint>
                        <publisher>
                           <xsl:choose>
                              <xsl:when test="$edID = 'LB98-L'">
                                 <xsl:text>J. &amp; A. Arch</xsl:text>
                              </xsl:when>
                              <xsl:when test="contains($edID, '98')">
                                 <xsl:text>[Cottle printing, London publisher not yet found]; title page reads
                                       T. N. Longman</xsl:text>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:text>T. N. Longman and O. Rees</xsl:text>
                              </xsl:otherwise>
                           </xsl:choose>
                        </publisher>
                        <pubPlace>
                           <xsl:choose>
                              <xsl:when test="$edID = 'lbphil-2'">Philadelphia</xsl:when>
                              <xsl:when test="substring-after($edID, '-') = 'campbell'">Philadelphia</xsl:when>
                              <xsl:when test="substring-after($edID, '-') = 'B'">Bristol</xsl:when>
                              <xsl:when test="substring-after($edID, '-') = 'b'">Bristol</xsl:when>
                              <xsl:when test="substring-after($edID, '-') = 'L'">London</xsl:when>
                              <xsl:when test="substring-after($edID, '-') = 'l'">London</xsl:when>
                           </xsl:choose>
                        </pubPlace>
                        <date>
                           <xsl:value-of select="$pubDate"/>
                        </date>
                     </imprint>
                     <biblScope unit="page">
                        <!-- this only works because I went through all the volumes and, as much as possible, each body
                           and front begins with <pb/><milestone/> -->
                        <!-- getting first page number -->
                        <xsl:choose>
                           <xsl:when test="preceding-sibling::tei:front">
                              <xsl:choose>
                                 <xsl:when test="*[2] = tei:milestone[@unit='page']">
                                    <xsl:value-of select="tei:milestone[@unit='page'][1]/@n"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:if test="*[1] = tei:pb and tei:pb[1] != ''">
                                       <xsl:value-of select="tei:pb[1]/@n"/>
                                    </xsl:if>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:choose>
                                 <xsl:when test="*[2] = tei:milestone[@unit='page']">
                                    <xsl:value-of select="tei:milestone[@unit='page'][1]/@n"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:if test="*[1] = tei:pb and tei:pb[1]/@n != ''">
                                       <xsl:value-of select="tei:pb[1]/@n"/>
                                    </xsl:if>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:otherwise>
                        </xsl:choose>
                        <!-- getting last page number -->
                        <xsl:choose>
                           <xsl:when test="preceding-sibling::tei:front">
                              <xsl:choose>
                                 <xsl:when test="following-sibling::tei:body/descendant-or-self::tei:milestone[@unit='page']/position()=2">
                                    <xsl:value-of select="concat(' to ', descendant-or-self::tei:milestone[@unit='page'][last()]/@n)"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:if test="following-sibling::tei:body/descendant-or-self::tei:pb[2] and following-sibling::tei:body/descendant-or-self::tei:pb/@n !=''">
                                       <xsl:value-of select="concat(' to ', descendant-or-self::tei:pb[last()]/@n)"/>
                                    </xsl:if>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:choose>
                                 <xsl:when test="descendant-or-self::tei:milestone[@unit='page']/position() = 2">
                                    <xsl:value-of select="concat(' to ', descendant-or-self::tei:milestone[@unit='page'][last()]/@n)"/>
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:if test="descendant-or-self::tei:pb[2] and descendant-or-self::tei:pb/@n !=''">
                                       <xsl:value-of select="concat(' to ', descendant-or-self::tei:pb[last()]/@n)"/>
                                    </xsl:if>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:otherwise>
                        </xsl:choose>
                     </biblScope>
                     <biblScope unit="pages">
                        <xsl:value-of select="count(descendant-or-self::tei:pb)"/>
                     </biblScope>
                  </monogr>
               </biblStruct>
            </sourceDesc>
         </fileDesc>
         <revisionDesc>
            <change when="20250731" who="#LM">
               Splurged out main xml into separate xml files for poems and paratexts.
            </change>
         </revisionDesc>
      </teiHeader>
      <text xmlns="http://www.tei-c.org/ns/1.0">
         <xsl:if test="parent::tei:text/tei:front">
            <xsl:apply-templates select="parent::tei:text/tei:front" mode="attached"/>
         </xsl:if>
               <body><xsl:apply-templates/></body>
      </text>
   </xsl:template>
   
   <xsl:template match="tei:ref[@type='endnote']">
      <ref xmlns="http://www.tei-c.org/ns/1.0" type="endnote">
         <xsl:if test="contains(@target, '#noteThorn')">
            <xsl:choose>
               <xsl:when test="$edID = 'LBP1-campbell'">
                  <xsl:attribute name="target" select="'../lbphil-2/lbphil-2_NOTES.html#noteThorn'"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="target" select="concat($edID, '_NOTES.html#noteThorn')"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:if>
         <xsl:if test="contains(@target, '#noteMariner')">
            <xsl:choose>
               <xsl:when test="$edID = 'LBP1-campbell'">
                  <xsl:attribute name="target" select="'../lbphil-2/lbphil-2_NOTES.html#noteMariner'"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="target" select="concat($edID, '_NOTES.html#noteMariner')"/>
               </xsl:otherwise>
            </xsl:choose>
            </xsl:if>
         <xsl:if test="contains(@target, '#noteTintern')">
            <xsl:choose>
               <xsl:when test="$edID = 'LBP1-campbell'">
                  <xsl:attribute name="target" select="'../lbphil-2/lbphil-2_NOTES.html#noteTintern'"/>
               </xsl:when>
            </xsl:choose>
            <xsl:attribute name="target" select="concat($edID, '_NOTES.html#noteTintern')"/>
            </xsl:if>
            <xsl:if test="contains(@target, '#NOTESmich')">
               <xsl:choose>
                  <xsl:when test="$edID = 'LBP1-campbell'">
                     <xsl:attribute name="target" select="'../lbphil-2/lbphil-2_NOTESmich.html'"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:attribute name="target" select="concat($edID, '_NOTESmich.html')"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:if>
         <xsl:if test="contains(@target, '#NOTESbro')">
            <xsl:choose>
               <xsl:when test="$edID = 'LBP1-campbell'">
                  <xsl:attribute name="target" select="concat($edID, '_NOTESbro.html')"/>
               </xsl:when>
            </xsl:choose>
            <xsl:attribute name="target" select="concat($edID, '_NOTESbro.html')"/>
         </xsl:if>
         <xsl:apply-templates/>
      </ref>
   </xsl:template>
   
   <xsl:template match="tei:body[@xml:id = 'toc']//tei:ref">
      <ref xmlns="http://www.tei-c.org/ns/1.0" type="single">
         <!-- here I remove the #; in the toWebLBsingle.xsl, I add "html." -->
         <xsl:attribute name="target">
            <xsl:value-of select="substring-after(@target, '#')"/>
         </xsl:attribute>
         <xsl:apply-templates/>
      </ref>
   </xsl:template>
   
   <xsl:template match="tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='local']">
      <xsl:choose>
         <xsl:when test="contains(., '_')">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
            <idno xmlns="http://www.tei-c.org/ns/1.0" type="local">
               <xsl:value-of select="concat(., '_TP')"/>
            </idno>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
</xsl:stylesheet>

