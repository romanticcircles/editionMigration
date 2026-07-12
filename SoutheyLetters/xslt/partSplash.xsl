<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei" version="3.0">
    <xsl:output method="xhtml" omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <xsl:param name="xmlname"/>
        <xsl:variable name="filename">
            <xsl:value-of select="substring-before($xmlname, '.xml')"/>
        </xsl:variable>    
        <xsl:result-document href="../HTML/{$filename}.html">
            <html lang="en">
                <xsl:comment>This HTML 5 page is generated from a TEI Master; do not edit.</xsl:comment>
                <xsl:apply-templates/>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader">
        <head>
            <title><xsl:value-of select="tei:fileDesc/tei:titleStmt/tei:title"/></title>
            <link rel="stylesheet" type="text/css" href="https://diged.org/DigitalEditions/DigitalEdition/css/style.css"/>/>
        </head>
    </xsl:template>
    
    <xsl:template match="tei:text">
        <body>
            <xsl:if test="tei:front">
                <xsl:apply-templates select="tei:front"/>
            </xsl:if>
            <main>
                <xsl:apply-templates select="tei:body"/>
            </main>
            <xsl:if test="tei:back">
                <xsl:apply-templates select="tei:back"/>
            </xsl:if>
            <xsl:if test="//tei:note">
                    <section class="notes">
                        <h2>Notes</h2>
                        <xsl:apply-templates select="//tei:note" mode="end"/>
                    </section>
                    <section class="noteSpace">
                        <h2>HTML constraints</h2>
                        <p>Makes enough space, 60em in the css, at the end of webpage for the note link to bring the specified note to the top of the screen.</p>
                    </section>
            </xsl:if>
        </body>
    </xsl:template>
 
 <!-- Templates exclusively in the <front> section -->
    
    <xsl:template match="tei:front">
        <div class="front">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:titlePage">
        <section class="titlePage">
            <h2><xsl:apply-templates select="//tei:docTitle"/></h2>
            <h3><xsl:apply-templates select="//tei:docAuthor"/></h3>
            <xsl:if test="tei:docImprint">
            <p><xsl:apply-templates select="//docImprint"/></p>
            </xsl:if>
        </section>
    </xsl:template>
    
        <!-- because <set> can only go inside <back> or <front>, use <stage> inside <body>
        https://tei-c.org/release/doc/tei-p5-doc/en/html/ref-set.html -->
    
    <xsl:template match="tei:set">
        <div class="set">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- templates dealing with structural elements in all sections -->
    
    <xsl:template match="tei:div">
        <div>
            <xsl:attribute name="class" select="@type"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:head">
        <header>
            <xsl:apply-templates/>
        </header>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p>
            <xsl:if test="@rend">
                <xsl:attribute name="class" select="@rend"/>
            </xsl:if>
            <xsl:if test="@type">
                <xsl:attribute name="class" select="@type"/>
            </xsl:if>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id" select="@xml:id"/>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:lg">
        <p class="stanza"><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:l">
        <span class="l">
            <xsl:choose>
                <xsl:when test="@rend">
                    <span>
                        <xsl:attribute name="class">
                            <xsl:value-of select="@rend"/>
                        </xsl:attribute>
                        <xsl:apply-templates/>
                    </span>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:quote">
        <xsl:choose>
            <xsl:when test="parent::tei:div">
                <div class="blockquote">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="parent::tei:p or parent::tei:l">
                <span class="quote">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- other main tags -->
    
    <xsl:template match="tei:title">
        <span>
            <xsl:attribute name="class">
        <xsl:choose>
            <xsl:when test="@level = 'a' or @level= 'u' or @level='s'">
                <xsl:value-of select="'titleQ'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'title'"/>
            </xsl:otherwise>
        </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:author">
        <span class="author"><xsl:apply-templates/></span>
    </xsl:template> <!-- the reason for this, css header author -->
    
   <xsl:template match="tei:hi[@rend='sup']">
       <sup><xsl:apply-templates/></sup>
   </xsl:template>
    
    <xsl:template match="tei:hi">
        <span>
            <xsl:attribute name="class" select="@rend"/>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:emph">
        <em><xsl:apply-templates/></em>
    </xsl:template>
    
    <xsl:template match="tei:lb">
        <br />
    </xsl:template>
    
    <xsl:template match="tei:pb">
        <span class="pageNumber">
            <xsl:value-of select="@n"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:fw">
        <xsl:if test="following-sibling::*[1][self::tei:fw]">
            <br /> <!-- needed for floating to work properly -->
        </xsl:if>
                <span>
                    <xsl:attribute name="class">
                        <xsl:value-of select="@type"/>
                    </xsl:attribute>
            <xsl:apply-templates/>
                </span>
    </xsl:template>
    
    <!-- drama -->
    
    <xsl:template match="tei:castList | tei:castGroup">
        <ul>
            <xsl:attribute name="class">
                <xsl:value-of select="name()"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    
    <xsl:template match="tei:castItem">
        <li><xsl:apply-templates/></li>
    </xsl:template>
    
    <xsl:template match="tei:role">
        <span class="role">
            <xsl:apply-templates/>
        </span>
        <xsl:if test="following-sibling::tei:roleDesc">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:roleDesc">
        <span class="roleDesc">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:stage">
        <span class="stage">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:sp">
        <p class="sp">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:speaker">
        <span class="speaker">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:sp/tei:p | tei:sp/tei:lg | tei:sp/tei:l">
        <span class="speech">
            <xsl:choose>
                <xsl:when test="@rend">
                <span>
                    <xsl:attribute name="class" select="@rend"/>
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>
    
    <!-- letters -->
    
    <xsl:template match="tei:opener">
        <p class="opener">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:signed">
        <span class="signed">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:postscript">
        <p class="postscript">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:salute">
        <span class="salute">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:dateline">
        <span class="dateline">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    
    <!-- end notes -->
   
    <xsl:template match="tei:note">
        <xsl:variable name="noteNumber">
            <xsl:number level="any"/>
        </xsl:variable>
        <span class="noteNumber">
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('#', $noteNumber)"/>
                </xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:value-of select="concat('back', $noteNumber)"/>
                </xsl:attribute>
            <sup><xsl:value-of select="$noteNumber"/></sup>
            </a>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:note" mode="end">
        <xsl:variable name="noteNumber">
            <xsl:number level="any"/>
        </xsl:variable>
            <p class="note">
                <xsl:attribute name="id" select="$noteNumber"/>
                <xsl:text>[</xsl:text><xsl:value-of select="$noteNumber"/><xsl:text>].  </xsl:text>
                <xsl:apply-templates/>
                <xsl:text> </xsl:text>
                <a>
                    <xsl:attribute name="href"><xsl:text>#back</xsl:text><xsl:value-of select="$noteNumber"
                    /></xsl:attribute>
                    <xsl:text>Back</xsl:text>
                </a>
            </p>
    </xsl:template>
    
</xsl:stylesheet>