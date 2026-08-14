<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei" version="3.0">
    
    <!-- run corresp.xml to generate corresp.html -->

    <xsl:output method="xhtml" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:key name="toLookup" match="name" use="@id"/>
    <xsl:key name="menLookup" match="name" use="@id"/>

    <xsl:variable name="docID"
        select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition']"/>

    <xsl:template match="tei:TEI">
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
        <xsl:result-document href="../../HTML/{$ptPath}/{$docID}.html">
            <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
            <html xml:lang="en" lang="en" id="idno"
                prefix="og: http://ogp.me/ns# dcterms: http://purl.org/dc/terms/ dc: http://purl.org/dc/elements/1.1/">
                <xsl:comment>This HTML 5 page is generated from a TEI Master; do not edit.</xsl:comment>
                <xsl:apply-templates/>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="tei:teiHeader">
        <xsl:variable name="getPath">
            <xsl:value-of select="tei:fileDesc/tei:editionStmt/tei:edition/@n"/>
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
        <xsl:variable name="letDate">
            <xsl:choose>
                <xsl:when test="//tei:div[@type = 'letter']">
                    <xsl:choose>
                        <xsl:when test="//tei:div[@type = 'letter'][1]/tei:head/tei:date/tei:choice">
                            <xsl:value-of
                                select="//tei:div[@type = 'letter'][1]/tei:head/tei:date/tei:choice/tei:corr/tei:date/@when"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="//tei:div[@type = 'letter'][1]/tei:head/tei:date/@when"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when
                            test="tei:fileDesc/tei:publicationStmt/tei:availability/tei:p/tei:date">
                            <xsl:value-of
                                select="tei:fileDesc/tei:publicationStmt/tei:availability/tei:p/tei:date/@when"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="tei:fileDesc/tei:editionStmt/tei:edition/tei:date"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="headTitle">
            <xsl:value-of
                select="normalize-space(concat(tei:fileDesc/tei:titleStmt/tei:title[@level = 'a'], ' ', tei:fileDesc/tei:titleStmt/tei:title[@level = 'm']))"
            />
        </xsl:variable>
        <xsl:variable name="correspIDs"
            select="distinct-values(//tei:ref[@type = 'a']/substring-after(@target, 'people.html#'))"/>
        <xsl:variable name="mentionedIDs"
            select="distinct-values(//tei:ref[@type = 'm']/substring-after(@target, 'people.html#'))"/>
        <xsl:variable name="placeIDs"
            select="distinct-values(tei:text//tei:ref/substring-after(@target, 'places.html#'))"/>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <title>
                <xsl:value-of select="$headTitle"/>
            </title>
            <meta name="viewport" content="width=device-width, initial-scale=1"/>
            <xsl:for-each select="tei:fileDesc/tei:titleStmt/tei:author">
                <xsl:choose>
                    <xsl:when test="tei:persName">
                        <meta name="author">
                            <xsl:attribute name="content">
                                <xsl:value-of
                                    select="concat(tei:persName/tei:forename, ' ', tei:persName/tei:surname)"
                                />
                            </xsl:attribute>
                        </meta>
                    </xsl:when>
                    <xsl:otherwise>
                        <meta name="author">
                            <xsl:attribute name="content">
                                <xsl:value-of select="normalize-space(.)"/>
                            </xsl:attribute>
                        </meta>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <meta name="DC.Title" content="{$headTitle}"/>
            <meta name="DC.Type" content="Text"/>
            <meta name="DC.Format" content="text/html"/>
            <meta property="og:title" content="{$headTitle}"/>
            <meta property="og:type" content="website"/>
            <meta property="og:url"
                content="https://cha.artsci.tamu.edu/SoutheyLetters/HTML/{$ptPath}/{$docID}.html"/>
            <!--add path -->
            <meta property="og:image"
                content="https://cha.artsci.tamu.edu/SoutheyLetters/images/RClogo.png"/>
            <meta property="og:description" content="Letters written by Robert Southey (1774-1843)"/>
            <meta property="og:site_name" content="The Collected Letters of Roberty Southey"/>
            <meta property="rc:id" content="{$docID}"/>
            <meta property="dc.contributor" content="Lynda Pratt"/>
            <meta property="dc.contributor" content="Laura Mandell"/>
            <meta property="dc:date" content="{$letDate}"/>
            <meta property="dcterms.available">
                <xsl:attribute name="content">
                    <xsl:value-of select="tei:fileDesc/tei:editionStmt/tei:edition/tei:date"/>
                </xsl:attribute>
            </meta>
            <meta property="dc.publisher" content="Romantic Circles"/>
            <meta property="dc.source" content="https://cha.artsci.tamu.edu/SoutheyLetters"/>
            <meta property="dc.type" content="Text"/>
            <meta property="dc.format" content="text/html"/>
            <meta property="dc.identifier"
                content="https://cha.artsci.tamu.edu/SoutheyLetters/HTML/{$ptPath}/{$docID}.html"/>
            <meta name="docTitle" class="staticSearch_docTitle">
                <xsl:attribute name="content"
                    select="normalize-space(tei:fileDesc/tei:titleStmt/tei:title[@level = 'a'])"/>
            </meta>
            <xsl:for-each select="tei:fileDesc/tei:titleStmt/tei:author">
                <xsl:choose>
                    <xsl:when test="tei:persName">
                        <meta name="docAuthor" class="staticSearch_docAuthor">
                            <xsl:attribute name="content">
                                <xsl:value-of
                                    select="concat(tei:persName/tei:forename, ' ', tei:persName/tei:surname)"
                                />
                            </xsl:attribute>
                        </meta>
                    </xsl:when>
                    <xsl:otherwise>
                        <meta name="docAuthor" class="staticSearch_docAuthor">
                            <xsl:attribute name="content">
                                <xsl:value-of select="normalize-space(.)"/>
                            </xsl:attribute>
                        </meta>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
            <meta name="Date Written" class="staticSearch_date">
                <xsl:attribute name="content" select="$letDate"/>
            </meta>
            <xsl:for-each select="$correspIDs">
                <xsl:variable name="currentID" select="."/>
                <xsl:for-each select="document('people_names.xml')">
                    <meta name="Correspondents" class="staticSearch_feat">
                        <xsl:attribute name="content">
                            <xsl:value-of select="key('personLookup', $currentID)"/>
                        </xsl:attribute>
                    </meta>
                </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$mentionedIDs">
                <xsl:variable name="currentID" select="."/>
                <xsl:for-each select="document('people_names.xml')">
                    <meta name="People mentioned" class="staticSearch_feat">
                        <xsl:attribute name="content">
                            <xsl:value-of select="key('personLookup', $currentID)"/>
                        </xsl:attribute>
                    </meta>
                </xsl:for-each>
            </xsl:for-each>
            <xsl:for-each select="$placeIDs">
                <xsl:variable name="currentID" select="."/>
                <xsl:for-each select="document('place_names.xml')">
                    <meta name="Places" class="staticSearch_feat">
                        <xsl:attribute name="content">
                            <xsl:value-of select="key('placeLookup', $currentID)"/>
                        </xsl:attribute>
                    </meta>
                </xsl:for-each>
            </xsl:for-each>
            <meta name="docSortKey" class="staticSearch_docSortKey"
                content="{substring-after(substring-after($docID, '.'), '.')}"/>
            <xsl:for-each select="tei:profileDesc/tei:textClass/tei:catRef[@scheme = 'VIAF']">
                <meta name="viaf">
                    <xsl:attribute name="content">
                        <xsl:value-of
                            select="concat('http://viaf.org/viaf/', substring-after(@target, '#'))"
                        />
                    </xsl:attribute>
                </meta>
            </xsl:for-each>
            <xsl:for-each select="tei:profileDesc/tei:textClass/tei:catRef[@scheme = 'Wikidata']">
                <meta name="Wikidata">
                    <xsl:attribute name="content">
                        <xsl:value-of
                            select="concat('https://www.wikidata.org/entity/', substring-after(@target, '#'))"
                        />
                    </xsl:attribute>
                </meta>
            </xsl:for-each>
            <link rel="stylesheet" type="text/css" href="../../css/southey.css"/>
            <link rel="icon" type="image/svg" href="../../images/favicon.ico"/>
            <link rel="preconnect" href="https://fonts.googleapis.com"/>
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
            <link
                href="https://fonts.googleapis.com/css2?family=Baskervville:ital,wght@0,400..700;1,400..700&amp;family=Pinyon+Script&amp;family=Space+Mono:ital,wght@0,400;0,700;1,400;1,700&amp;display=swap"
                rel="stylesheet"/>
            <xsl:if test="tei:encodingDesc/tei:tagsDecl">
                <style>
					<xsl:for-each select="tei:encodingDesc/tei:tagsDecl/tei:rendition">
						<xsl:value-of select="concat('.', @xml:id, ' {')"/>
						<xsl:value-of select="."/>
						<xsl:text>}</xsl:text>
					</xsl:for-each>
				</style>
            </xsl:if>
        </head>
    </xsl:template>

    <xsl:template match="tei:text">
        <body>
            <nav id="top">
                <p class="navTitle"><a href="../../index.html">The Collected Letters of Robert
                        Southey</a><br/>Gen. Ed. Lynda Pratt</p>
                <p class="homePlink">
                    <a href="index.html">
                        <img src="../../images/GretaHall3.png" alt="Greta Hall home button"
                            class="homeButton"/>
                    </a>
                </p>
                <ul class="nav">
                    <li class="nav">
                        <span class="drop">Parts</span>
                        <ul class="dropdown">
                            <li>
                                <a href="../../index.html">All</a>
                            </li>
                            <li>
                                <a href="../Part_One/index.html">One (1791-1797)</a>
                            </li>
                            <li>
                                <a href="../Part_Two/index.html">Two (1798-1803)</a>
                            </li>
                            <li>
                                <a href="../Part_Three/index.html">Three (1804-1809)</a>
                            </li>
                            <li>
                                <a href="../Part_Four/index.html">Four (1810-1815)</a>
                            </li>
                            <li>
                                <a href="../Part_Five/index.html">Five (1816-1818)</a>
                            </li>
                            <li>
                                <a href="../Part_Six/index.html">Six (1819-1821)</a>
                            </li>
                            <li>
                                <a href="../Part_Seven/index.html">Seven (1822-1824)</a>
                            </li>
                            <li>
                                <a href="../Part_Eight/index.html">Eight (1825-1827)</a>
                            </li>
                            <li>
                                <a href="../Part_Nine/index.html">Nine (1828-1830)</a>
                            </li>
                            <li>
                                <a href="../Part_Ten/index.html">Ten (1831-1833)</a>
                            </li>
                            <li>
                                <a href="../Part_Eleven/index.html">Eleven (1834-1836)</a>
                            </li>
                            <li>
                                <a href="../Part_Twelve/index.html">Twelve (1837-1839)</a>
                            </li>
                        </ul>
                    </li>
                    <li class="nav">
                        <span class="drop">People</span>
                        <ul class="dropdown">
                            <li>
                                <a href="people.html">All</a>
                            </li>
                            <li>
                                <span class="here">Correspondents</span>
                            </li>
                            <li>
                                <a href="mentioned.html">People mentioned</a>
                            </li>
                        </ul>
                    </li>
                    <li class="nav">
                        <a href="places.html">Places</a>
                    </li>
                    <li class="nav">
                        <a href="chrono.html">Chronology</a>
                    </li>
                    <li class="nav">
                        <span class="drop">Appendices</span>
                        <ul class="dropdown">
                            <li>
                                <a href="appendices.html">All</a>
                            </li>
                            <li>
                                <a href="appendix1.html">Appendix 1</a>
                            </li>
                            <li>
                                <a href="appendix2.html">Appendix 2</a>
                            </li>
                            <li>
                                <a href="appendix3.html">Appendix 3</a>
                            </li>
                            <li>
                                <a href="appendix4.html">Appendix 4</a>
                            </li>
                        </ul>
                    </li>
                    <li class="nav">
                        <a href="../search.html">Search</a>
                    </li>
                </ul>
            </nav>
            <main>
                <xsl:apply-templates select="tei:body"/>
                <xsl:if test="//tei:note">
                    <div class="notes">
                        <h1>Notes</h1>
                        <xsl:apply-templates select="//tei:note" mode="end"/>
                    </div>
                </xsl:if>
            </main>
            <p class="noteSpace">&#160;</p>
            <script>
                <xsl:text disable-output-escaping="yes">
                document.addEventListener('DOMContentLoaded', () => {
                document.body.addEventListener('click', (event) => {
                const toggle = event.target.closest('.toToggle, .menToggle');
                if (toggle) {
                toggle.classList.toggle('expanded');
                }
                });
                });
                </xsl:text>
            </script>
        </body>
    </xsl:template>

    <!-- 
		 =======================================================
			structural elements in all documents-->

    <xsl:template match="tei:div">
        <a href="../../XML/paratext/corresp.xml">
            <img src="../../images/TEI_Logo.png" alt="TEI logo" class="teiLogo" style="margin-right: 2rem;"/>
        </a>
        <div class="paratext">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="tei:div/tei:head">
        <h1>
            <xsl:apply-templates/>
        </h1>
        <p style="text-align: center; margin-left: -2rem;">
            <span class="dir"><a href="#toCorr">Named Correspondents</a> | </span>
            <span class="dir"><a href="#unknown">Unknown Correspondents</a> | </span>
            <span class="dir">
                <a href="#appLetters">Correspondents in the Appendices | </a>
            </span>
            <span class="dir">(See also <a href="mentioned.html">people mentioned</a> in the letters.)</span>
        </p>
    </xsl:template>

    <xsl:template match="tei:p">
        <xsl:choose>
            <xsl:when test="@xml:id">
                <h2>
                    <xsl:attribute name="id" select="@xml:id"/>
                    <xsl:apply-templates/>
                </h2>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:list">
        <xsl:choose>
            <xsl:when test="@type = 'corresp'">
                <ul class="corresp">
                    <xsl:apply-templates/>
                </ul>
            </xsl:when>
            <xsl:when test="@type = 'uk'">
                <ul class="{@type}">
                    <xsl:apply-templates select="tei:item" mode="unknown"/>
                </ul>
            </xsl:when>
            <xsl:when test="@type = 'appLet'">
                <ul class="{@type}">
                    <xsl:apply-templates select="tei:item" mode="appendixLetters"/>
                </ul>
            </xsl:when>
        </xsl:choose>
        <p><a href="#top"><em>Back to Top</em></a></p>
    </xsl:template>

    <xsl:template match="tei:item" mode="unknown">
        <!-- this will need to be changed when automatically generating unknowns-->
        <li>
            <a>
                <xsl:attribute name="href" select="tei:ref/@target"/>
                <xsl:value-of select="substring-before(., ',')"/>
            </a>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="substring-after(., ',')"/>
        </li>
    </xsl:template>

    <xsl:template match="tei:item" mode="appendixLetters">
        <li>
            <xsl:if test="substring-before(., tei:ref) != ''">
                <xsl:value-of select="substring-before(., tei:ref)"/>
            </xsl:if>
            <a>
                <xsl:attribute name="href" select="tei:ref/@target"/>
                <xsl:value-of select="tei:ref"/>
            </a>
            <xsl:if test="substring-after(., tei:ref) != ''">
                <xsl:value-of select="substring-after(., tei:ref)"/>
            </xsl:if>
        </li>
    </xsl:template>

    <xsl:template match="tei:item">
        <xsl:variable name="persID">
            <xsl:value-of select="substring-after(tei:ref/@target, 'people.html#')"/>
        </xsl:variable>
        <xsl:variable name="nameOnly" select="tei:ref/text()"/>
        <!-- the following generates the csv files -->
        <xsl:choose>
            <xsl:when test="parent::tei:list[@type = 'uk']"/>
            <xsl:when test="parent::tei:list[@type = 'apLet']"/>
            <xsl:otherwise>
                <xsl:result-document href="../../HTML/personsCSV/{$persID}.csv">
                    <xsl:text>&quot;</xsl:text>
                    <xsl:apply-templates select="$nameOnly"/>
                    <xsl:text>&quot;</xsl:text>
                    <xsl:text disable-output-escaping="yes">&#13;</xsl:text>
                    <xsl:text disable-output-escaping="yes">&#13;</xsl:text>
                    <xsl:text>Letters To:, URL</xsl:text>
                    <xsl:text disable-output-escaping="yes">&#13;</xsl:text>
                    <xsl:for-each
                        select="key('toLookup', $persID, doc(resolve-uri('../TOall.xml', base-uri(/))))">
                        <xsl:for-each select="parent::to">
                            <xsl:for-each select="letter">
                                <xsl:variable name="letterID" select="@id"/>
                                <xsl:variable name="getPath">
                                    <xsl:value-of
                                        select="substring-before(substring-after($letterID, 'southey.'), '.')"
                                    />
                                </xsl:variable>
                                <xsl:variable name="ptPath">
                                    <xsl:choose>
                                        <xsl:when test="$getPath = '1'">Part_One</xsl:when>
                                        <xsl:when test="$getPath = '2'">Part_Two</xsl:when>
                                        <xsl:when test="$getPath = '3'">Part_Three</xsl:when>
                                        <xsl:when test="$getPath = '4'">Part_Four</xsl:when>
                                        <xsl:when test="$getPath = '5'">Part_Five</xsl:when>
                                        <xsl:when test="$getPath = '6'">Part_Six</xsl:when>
                                        <xsl:when test="$getPath = '7'">Part_Seven</xsl:when>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:text>&quot;</xsl:text>
                                <xsl:apply-templates/>
                                <xsl:text>&quot;</xsl:text>
                                <xsl:text>,</xsl:text>
                                <xsl:value-of
                                    select="concat('https://cha.artsci.tamu.edu/SoutheyLetters/HTML/', $ptPath, '/', $letterID, '.html')"/>
                                <xsl:text disable-output-escaping="yes">&#13;</xsl:text>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:text disable-output-escaping="yes">&#13;</xsl:text>
                    <xsl:text disable-output-escaping="yes">&#13;</xsl:text>
                    <xsl:text>Mentioned In:, URL</xsl:text>
                    <xsl:text disable-output-escaping="yes">&#13;</xsl:text>
                    <xsl:for-each
                        select="key('toLookup', $persID, doc(resolve-uri('../INall.xml', base-uri(/))))">
                        <xsl:for-each select="parent::person">
                            <xsl:for-each select="letter">
                                <xsl:variable name="letterID" select="@id"/>
                                <xsl:variable name="getPath">
                                    <xsl:value-of
                                        select="substring-before(substring-after($letterID, 'southey.'), '.')"
                                    />
                                </xsl:variable>
                                <xsl:variable name="ptPath">
                                    <xsl:choose>
                                        <xsl:when test="$getPath = '1'">Part_One</xsl:when>
                                        <xsl:when test="$getPath = '2'">Part_Two</xsl:when>
                                        <xsl:when test="$getPath = '3'">Part_Three</xsl:when>
                                        <xsl:when test="$getPath = '4'">Part_Four</xsl:when>
                                        <xsl:when test="$getPath = '5'">Part_Five</xsl:when>
                                        <xsl:when test="$getPath = '6'">Part_Six</xsl:when>
                                        <xsl:when test="$getPath = '7'">Part_Seven</xsl:when>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:text>&quot;</xsl:text>
                                <xsl:apply-templates/>
                                <xsl:text>&quot;</xsl:text>
                                <xsl:text>,</xsl:text>
                                <xsl:value-of
                                    select="concat('https://cha.artsci.tamu.edu/SoutheyLetters/HTML/', $ptPath, '/', $letterID, '.html')"/>
                                <xsl:text disable-output-escaping="yes">&#13;</xsl:text>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>
        <!-- the following generates the <li> in corresp.html -->
        <li>
            <xsl:apply-templates/>
            <a href="../../HTML/personsCSV/{$persID}.csv">
                <img src="../../images/CSVIcon.png" class="csvIcon" alt="link to download csv file"
                />
            </a>
            <xsl:choose>
                <xsl:when test="parent::tei:list[@type = 'uk']"/>
                <xsl:when test="parent::tei:list[@type = 'apLet']"/>
                <xsl:otherwise>
                    <br/>
                    <span class="toToggle">Letters To:</span>
                    <ul class="correspToList">
                        <xsl:call-template name="getToList">
                            <xsl:with-param name="toPers" select="$persID"/>
                        </xsl:call-template>
                    </ul>
                    <span class="menToggle">Mentioned:</span>
                    <ul class="correspMenList">
                        <xsl:call-template name="getMenList">
                            <xsl:with-param name="menPers" select="$persID"/>
                        </xsl:call-template>
                    </ul>
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <xsl:template match="tei:ref">
        <xsl:variable name="refNo">
            <xsl:number select="." level="any"/>
            <!--This is for staticSearch -->
        </xsl:variable>
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="@target"/>
            </xsl:attribute>
            <xsl:attribute name="id">
                <xsl:value-of select="concat('ref.corresp.', $refNo)"/>
                <!--This is for staticSearch -->
            </xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <xsl:template match="tei:title">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>

    <xsl:template name="getToList">
        <xsl:param name="toPers"/>
        <xsl:for-each
            select="key('toLookup', $toPers, doc(resolve-uri('../TOall.xml', base-uri(/))))">
            <xsl:for-each select="parent::to">
                <xsl:for-each select="letter">
                    <xsl:variable name="letterID" select="@id"/>
                    <xsl:variable name="getPath">
                        <xsl:value-of
                            select="substring-before(substring-after($letterID, 'southey.'), '.')"/>
                    </xsl:variable>
                    <xsl:variable name="ptPath">
                        <xsl:choose>
                            <xsl:when test="$getPath = '1'">Part_One</xsl:when>
                            <xsl:when test="$getPath = '2'">Part_Two</xsl:when>
                            <xsl:when test="$getPath = '3'">Part_Three</xsl:when>
                            <xsl:when test="$getPath = '4'">Part_Four</xsl:when>
                            <xsl:when test="$getPath = '5'">Part_Five</xsl:when>
                            <xsl:when test="$getPath = '6'">Part_Six</xsl:when>
                            <xsl:when test="$getPath = '7'">Part_Seven</xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <li>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of
                                    select="concat('../', $ptPath, '/', $letterID, '.html')"/>
                            </xsl:attribute>
                            <xsl:value-of select="substring-before(., ',')"/>
                        </a>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="substring-after(., ',')"/>
                    </li>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="getMenList">
        <xsl:param name="menPers"/>
        <xsl:for-each
            select="key('menLookup', $menPers, doc(resolve-uri('../INall.xml', base-uri(/))))">
            <xsl:for-each select="parent::person">
                <xsl:for-each select="letter">
                    <xsl:variable name="letterID" select="@id"/>
                    <xsl:variable name="getPath">
                        <xsl:value-of
                            select="substring-before(substring-after($letterID, 'southey.'), '.')"/>
                    </xsl:variable>
                    <xsl:variable name="ptPath">
                        <xsl:choose>
                            <xsl:when test="$getPath = '1'">Part_One</xsl:when>
                            <xsl:when test="$getPath = '2'">Part_Two</xsl:when>
                            <xsl:when test="$getPath = '3'">Part_Three</xsl:when>
                            <xsl:when test="$getPath = '4'">Part_Four</xsl:when>
                            <xsl:when test="$getPath = '5'">Part_Five</xsl:when>
                            <xsl:when test="$getPath = '6'">Part_Six</xsl:when>
                            <xsl:when test="$getPath = '7'">Part_Seven</xsl:when>
                        </xsl:choose>
                    </xsl:variable>
                    <li>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of
                                    select="concat('../', $ptPath, '/', $letterID, '.html')"/>
                            </xsl:attribute>
                            <xsl:value-of select="substring-before(., ',')"/>
                        </a>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="substring-after(., ',')"/>
                    </li>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>


</xsl:stylesheet>
