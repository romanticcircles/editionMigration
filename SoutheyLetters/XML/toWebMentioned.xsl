<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="3.0">

    <!-- create this html page by running this xslt on INall.xml -->

    <!--  =======================================================
		revision history
	00-began with fork from /xslt/masters/HTMLtransform.xsl
	01-filled master with needed code
	02-revised plays, simplified by eliminating TOC
	03-created for CritArchive 
	04-changes 09/20/2021
	05-new, combining LL, LM, and SN, as of 8/24/22
	06-revised for P4H Fall 2022, as of 11/18/22
	07-revised for Southey 07/2026
	-->

    <!-- =======================================================
		running documents -->

    <xsl:output method="xhtml" encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="mentions">
        <html xml:lang="en" lang="en" id="idno"
            prefix="og: http://ogp.me/ns# dcterms: http://purl.org/dc/terms/ dc: http://purl.org/dc/elements/1.1/">
            <xsl:comment>This HTML 5 page is generated from a TEI Master; do not edit.</xsl:comment>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                <title>People Mentioned in The Collected Letters of Robert Southey</title>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <meta name="author" content="Lynda Pratt"/>
                <meta name="DC.Title"
                    content="People Mentioned in The Collected Letters of Robert Southey"/>
                <meta name="DC.Type" content="Text"/>
                <meta name="DC.Format" content="text/html"/>
                <meta property="og:title"
                    content="People Mentioned in The Collected Letters of Robert Southey"/>
                <meta property="og:type" content="website"/>
                <meta property="og:url"
                    content="https://cha.artsci.tamu.edu/SoutheyLetters/HTML/paratext/mentioned.html"/>
                <meta property="og:image"
                    content="https://cha.artsci.tamu.edu/SoutheyLetters/images/RClogo.png"/>
                <meta property="og:description"
                    content="List of Letters written by Robert Southey (1774-1843)"/>
                <meta property="og:site_name" content="The Collected Letters of Roberty Southey"/>
                <meta property="rc:id" content="listss"/>
                <meta property="dc.contributor" content="Lynda Pratt"/>
                <meta property="dc.contributor" content="Laura Mandell"/>
                <meta property="dc:date" content="2009 to present"/>
                <meta property="dcterms.available" content="2026-09-15"/>
                <meta property="dc.publisher" content="Romantic Circles"/>
                <meta property="dc.source" content="https://cha.artsci.tamu.edu/SoutheyLetters"/>
                <meta property="dc.type" content="Text"/>
                <meta property="dc.format" content="text/html"/>
                <meta property="dc.identifier"
                    content="https://cha.artsci.tamu.edu/SoutheyLetters/HMTL/paratext/mentioned.html"/>
                <meta name="docTitle" class="staticSearch_docTitle" content="Places"/>
                <meta name="docAuthor" class="staticSearch_docAuthor" content="Lynda Pratt"/>
                <meta name="Date Written" class="staticSearch_date" content="2009"/>
                <meta name="docSortKey" class="staticSearch_docSortKey" content="lists"/>
                <meta name="viaf" content="http://viaf.org/viaf/61576896"/>
                <meta name="viaf" content="http://viaf.org/viaf/118520952"/>
                <meta name="viaf" content="http://viaf.org/viaf/250654121"/>
                <meta name="viaf" content="http://viaf.org/viaf/41749340"/>
                <meta name="Wikidata" content="https://www.wikidata.org/entity/Q36279"/>
                <meta name="Wikidata" content="https://www.wikidata.org/entity/Q216838"/>
                <meta name="Wikidata" content="https://www.wikidata.org/entity/Q5977111"/>
                <meta name="Wikidata" content="https://www.wikidata.org/entity/Q1277575"/>
                <link rel="stylesheet" href="../../css/southey.css"/>
                <link rel="icon" type="image/svg" href="../../images/favicon.ico"/>
                <link rel="preconnect" href="https://fonts.googleapis.com"/>
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
                <link
                    href="https://fonts.googleapis.com/css2?family=Baskervville:ital,wght@0,400..700;1,400..700&amp;family=Pinyon+Script&amp;family=Space+Mono:ital,wght@0,400;0,700;1,400;1,700&amp;display=swap"
                    rel="stylesheet"/>
            </head>
            <body>
                <nav id="top">
                    <p class="navTitle"><a href="../../index.html">The Collected Letters of Robert
                            Southey</a><br/>Gen. Ed. Lynda Pratt</p>
                    <p class="homePlink">
                        <a href="../../index.html">
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
                                    <a href="../paratext/people.html">All</a>
                                </li>
                                <li>
                                    <a href="../paratext/corresp.html">Correspondents</a>
                                </li>
                                <li>
                                    <a href="../paratext/mentioned.html">People mentioned</a>
                                </li>
                            </ul>
                        </li>
                        <li class="nav">
                            <span class="here">Places</span>
                        </li>
                        <li class="nav">
                            <a href="../paratext/chrono.html">Chronology</a>
                        </li>
                        <li class="nav">
                            <span class="drop">Appendices</span>
                            <ul class="dropdown">
                                <li>
                                    <a href="../paratext/appendices.html">All</a>
                                </li>
                                <li>
                                    <a href="../paratext/appendix1.html">Appendix 1</a>
                                </li>
                                <li>
                                    <a href="../paratext/appendix2.html">Appendix 2</a>
                                </li>
                                <li>
                                    <a href="../paratext/appendix3.html">Appendix 3</a>
                                </li>
                                <li>
                                    <a href="../paratext/appendix4.html">Appendix 4</a>
                                </li>
                            </ul>
                        </li>
                        <li class="nav">
                            <a href="../search.html">Search</a>
                        </li>
                    </ul>
                </nav>
                <main>
                    <div class="paratext">
                        <h1>People Mentioned in</h1>
                        <h2>The Collected Letters of Robert Southey</h2>
                        <h3>(and letters addressed to them)</h3>
                    </div>
                    <xsl:for-each select="person">
                        <div class="entry">
                            <hr/><hr/>
                            <h4 class="listName">
                                <a href="people.html#{name/@id}">
                                    <xsl:apply-templates select="name"/>
                                </a>
                            </h4>
                            <figure class="downloadCSV"><a href="../personsCSV/{name/@id}.csv">
                                    <img src="../../images/CSVIcon.png" alt="icon for CSV download" class="csvIcon"/>
                            </a></figure>
                            <div class="lists">
                                <div class="menList">
                                    <h5 class="menHdr">Mentioned In:</h5>
                                    <ul>
                                        <xsl:apply-templates select="letter"/>
                                    </ul>
                                </div>
                                <div class="toList">
                                    <h5 class="toHdr">Letters To:</h5>
                                    <ul class="letList">
                                        <xsl:call-template name="getTo">
                                            <xsl:with-param name="idNbr" select="name/@id"/>
                                        </xsl:call-template>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </xsl:for-each>
                </main>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="letter">
        <xsl:variable name="getPath">
            <xsl:value-of select="substring-before(substring-after(@id, 'southey.'), '.')"/>
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
            <a href="../{$ptPath}/{@id}.html">
                <xsl:value-of select="substring-before(., ',')"/>
            </a>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="substring-after(., ', ')"/>
        </li>
    </xsl:template>

    <xsl:template name="getTo">
        <xsl:param name="idNbr"/>
        <xsl:for-each select="document('TOall.xml')/corresp/to/name[@id = $idNbr]">
            <xsl:for-each select="following-sibling::letter">
                <xsl:variable name="getPath">
                    <xsl:value-of select="substring-before(substring-after(@id, 'southey.'), '.')"/>
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
                    <a href="../{$ptPath}/{@id}.html">
                        <xsl:value-of select="substring-before(., ',')"/>
                    </a>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="substring-after(., ', ')"/>
                </li>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
