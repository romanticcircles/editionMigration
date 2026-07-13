<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei" version="3.0">
    <xsl:output method="xhtml" omit-xml-declaration="yes" indent="yes" encoding="UTF-8"/>
    
    <xsl:variable name="docId" select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:TEI">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xml:lang="en" lang="en" id="{$docId}" prefix="og: http://ogp.me/ns# dcterms: http://purl.org/dc/terms/ dc: http://purl.org/dc/elements/1.1/">
            <xsl:apply-templates/>
        </html>
    </xsl:template>

    <xsl:template match="tei:teiHeader">
        <xsl:variable name="ptNbr">
            <xsl:value-of select="normalize-space(substring-before(substring-after(tei:fileDesc/tei:editionStmt/tei:edition, 'Part'), tei:fileDesc/tei:editionStmt/tei:edition/tei:date))"/>
        </xsl:variable>
        <xsl:variable name="metaTitle">
            <xsl:value-of
                select="concat('Southey, Collected Letters, ', tei:fileDesc/tei:titleStmt/tei:title[@type = 'main'])"
            />
        </xsl:variable>
        <xsl:variable name="itemDate">
            <xsl:value-of select="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div/tei:p[1]"/>
        </xsl:variable>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <title><xsl:value-of select="$metaTitle"/></title>
            <meta name="viewport" content="width=device-width, initial-scale=1"/>
            <meta name="author" content="Robert Southey" />
            <meta name="DC.Title" content="{$metaTitle}" />
            <meta name="DC.Type" content="Text" />
            <meta name="DC.Format" content="text/html" />
            <meta property="og:title" content="{$metaTitle}" /> 
            <meta property="og:type" content="website" />
            <meta property="og:url" content="https://cha.artsci.tamu.edu/SoutheyLetters/HTML/Part_{$ptNbr}/index.html" />
            <meta property="og:image"
                content="https://cha.artsci.tamu.edu/SoutheyLetters/images/RClogo.png" />
            <meta property="og:description" content="Letters written by Robert Southey (1774-1843)" />
            <meta property="og:site_name" content="The Collected Letters of Roberty Southey" />
            <meta property="rc:id" content="{$docId}" />
            <meta property="dc.contributor" content="Lynda Pratt" />
            <meta property="dc.contributor" content="Laura Mandell" />
            <meta property="dc:date" content="{$itemDate}" />
            <meta property="dcterms.available" content="2026-07-20" />
            <meta property="dc.publisher" content="Romantic Circles" />
            <meta property="dc.source" content="https://cha.artsci.tamu.edu/SoutheyLetters" />
            <meta property="dc.type" content="Text" />
            <meta property="dc.format" content="text/html" />
            <link rel="stylesheet" href="../../css/southey.css"/>
            <link rel="icon" type="image/svg" href="../../images/favicon.ico"/>
            <link rel="preconnect" href="https://fonts.googleapis.com"/>
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
            <link
                href="https://fonts.googleapis.com/css2?family=Baskervville:ital,wght@0,400..700;1,400..700&amp;family=Pinyon+Script&amp;family=Space+Mono:ital,wght@0,400;0,700;1,400;1,700&amp;display=swap"
                rel="stylesheet"/>
        </head>
    </xsl:template>

    <xsl:template match="tei:text">
        <xsl:apply-templates select="tei:body"/>
    </xsl:template>

    <xsl:template match="tei:body">
        <xsl:variable name="getPart">
            <xsl:value-of
                select="normalize-space(substring-before(ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:editionStmt/tei:edition, ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:editionStmt/tei:edition/tei:date))"
            />
        </xsl:variable>
        <xsl:variable name="getPtNbr">
            <xsl:value-of select="normalize-space(substring-after($getPart, 'Part'))"/>
        </xsl:variable>
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
                        <a href="../paratext/places.html">Places</a>
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
                                <a href="../paratext/appendix3.html">Appendix 2</a>
                            </li>
                            <li>
                                <a href="../paratext/appendix4.html">Appendix 2</a>
                            </li>
                        </ul>
                    </li>
                    <li class="nav">
                        <a href="../search.html">Search</a>
                    </li>
                </ul>
            </nav>
            <main>
                <div class="letList">
                    <h1>The Collected Letters of Robert Southey</h1>
                    <h2>
                        <xsl:value-of
                            select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type = 'main']"
                        />
                    </h2>
                    <ul>
                        <li>
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of
                                        select="concat('southey.part', $getPtNbr, 'Intro.html')"/>
                                </xsl:attribute>
                                <xsl:text>Introduction to </xsl:text>
                                <xsl:value-of select="$getPart"/>
                            </a>
                        </li>
                        <li>
                            <a href="#llst">Letters dated:</a>
                            <ul>
                                <xsl:for-each select="tei:div/tei:p">
                                    <li>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="concat('#', ., 'y')"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="."/>
                                        </a>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </li>
                    </ul>
                    <hr/>
                    <xsl:apply-templates select="tei:div"/>
                </div>
            </main>
        </body>
    </xsl:template>

    <xsl:template match="tei:div">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:head">
        <h2 id="llst"><xsl:value-of select="."/></h2>
    </xsl:template>

    <xsl:template match="tei:p">
        <h3>
            <xsl:attribute name="id" select="concat(., 'y')"/>
            <strong>
                <xsl:value-of select="."/>
            </strong>
        </h3>
    </xsl:template>

    <xsl:template match="tei:list">
        <ul class="letYrList">
            <xsl:apply-templates select="tei:item"/>
        </ul>
        <p><em><a href="#top">Back to top</a></em></p>
    </xsl:template>

    <xsl:template match="tei:item">
        <li>
            <xsl:attribute name="id" select="@n"/>
        <xsl:apply-templates/>
        </li>
    </xsl:template>

    <xsl:template match="tei:ref">
        <xsl:variable name="bareNbr">
            <xsl:value-of select="substring-after(@target, 'letterEEd.26.')"/>
        </xsl:variable>
        <xsl:variable name="barePtNbr">
            <xsl:value-of
                select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:editionStmt/tei:edition/@n"/>
        </xsl:variable>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('southey.', $barePtNbr, '.', $bareNbr)"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </a>
            <xsl:text> </xsl:text>
    </xsl:template>

</xsl:stylesheet>
