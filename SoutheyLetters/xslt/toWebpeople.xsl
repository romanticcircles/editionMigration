<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="http://example.com/functions"
    exclude-result-prefixes="xs tei my" version="3.0">

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

    <xsl:output method="xhtml"  encoding="UTF-8" omit-xml-declaration="yes" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    <!-- Helper function to extract the sort string for a given person -->
    <xsl:function name="my:get-sort-name" as="xs:string">
        <xsl:param name="person" as="element(tei:person)"/>
        <xsl:variable name="pName" select="$person/tei:persName"/>
        <xsl:choose>
            <xsl:when test="$pName/tei:surname[@type = 'married']">
                <xsl:value-of select="$pName/tei:surname[@type = 'married']"/>
            </xsl:when>
            <xsl:when test="$pName/tei:surname[@type = 'grp']">
                <xsl:value-of select="$pName/tei:surname[@type = 'grp']"/>
            </xsl:when>
            <xsl:when test="$pName/tei:surname[@type = 'dynasty']">
                <xsl:value-of select="$pName/tei:forename"/>
            </xsl:when>
            <xsl:when test="$pName/tei:surname[not(@type)]">
                <xsl:value-of select="$pName/tei:surname[not(@type)]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$pName/tei:surname[1]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:variable name="lastName">
        <xsl:for-each select="tei:TEI/tei:text/tei:body/tei:div/tei:listPerson/tei:person/tei:persName/tei:surname">
            <xsl:choose>
                <xsl:when test=".[2]">
                    <xsl:if test="@type = 'married'">
                        <xsl:value-of select=".[@type = 'married']"/>
                    </xsl:if>
                    <xsl:if test="@type = 'married1'">
                        <xsl:value-of select=".[@type = 'married1']"/>
                    </xsl:if>
                    <xsl:if test="@type = 'grp'">
                        <xsl:value-of select=".[@type = 'grp']"/>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="@type = 'dynasty'">
                            <xsl:value-of
                                select="substring-before(preceding-sibling::tei:forename[1], ' ')"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="tei:surname[1]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:TEI">
            <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
            <html xml:lang="en" lang="en" id="idno"
                prefix="og: http://ogp.me/ns# dcterms: http://purl.org/dc/terms/ dc: http://purl.org/dc/elements/1.1/">
                <xsl:comment>This HTML 5 page is generated from a TEI Master; do not edit.</xsl:comment>
                <xsl:apply-templates/>
            </html>
    </xsl:template>

    <xsl:template match="tei:teiHeader">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <title>Biographies, Southey Letters</title>
            <meta name="viewport" content="width=device-width, initial-scale=1"/>
            <meta name="author" content="Lynda Pratt"/>
            <meta name="DC.Title" content="Biographies, Southey Letters"/>
            <meta name="DC.Type" content="Text"/>
            <meta name="DC.Format" content="text/html"/>
            <meta property="og:title" content="Biographies, Southey Letters"/>
            <meta property="og:type" content="website"/>
            <meta property="og:url"
                content="https://cha.artsci.tamu.edu/SoutheyLetters/HTML/paratext/people.html"/>
            <meta property="og:image"
                content="https://cha.artsci.tamu.edu/SoutheyLetters/images/RClogo.png"/>
            <meta property="og:description" content="Letters written by Robert Southey (1774-1843)"/>
            <meta property="og:site_name" content="The Collected Letters of Roberty Southey"/>
            <meta property="rc:id" content="people"/>
            <meta property="dc.contributor" content="Lynda Pratt"/>
            <meta property="dc.contributor" content="Laura Mandell"/>
            <meta property="dc:date" content="2009 to present"/>
            <meta property="dcterms.available">
                <xsl:attribute name="content">
                    <xsl:value-of select="tei:fileDesc/tei:editionStmt/tei:edition/tei:date"/>
                </xsl:attribute>
            </meta>
            <meta property="dc.publisher" content="Romantic Circles"/>
            <meta property="dc.source" content="https://cha.artsci.tamu.edu/SoutheyLetters"/>
            <meta property="dc.type" content="Text"/>
            <meta property="dc.format" content="text/html"/>
            <meta property="dc.identifier" content="https://cha.artsci.tamu.edu/SoutheyLetters/HTML/paratext/people.html" />
            <meta name="docTitle" class="staticSearch_docTitle" content="Biorgraphies" />
            <meta name="docAuthor" class="staticSearch_docAuthor" content="Lynda Pratt" />
            <meta name="Date Written" class="staticSearch_date" content="2009" />
            <meta name="docSortKey" class="staticSearch_docSortKey" content="people" />
            <meta name="viaf" content="http://viaf.org/viaf/61576896" />
            <meta name="viaf" content="http://viaf.org/viaf/118520952" />
            <meta name="viaf" content="http://viaf.org/viaf/250654121" />
            <meta name="viaf" content="http://viaf.org/viaf/41749340" />
            <meta name="Wikidata" content="https://www.wikidata.org/entity/Q36279"/>
            <meta name="Wikidata" content="https://www.wikidata.org/entity/Q216838" />
            <meta name="Wikidata" content="https://www.wikidata.org/entity/Q5977111" />
            <meta name="Wikidata" content="https://www.wikidata.org/entity/Q1277575" />
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
                                <span class="here">All</span>
                            </li>
                            <li>
                                <a href="corresp.html">Correspondents</a>
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
                <xsl:apply-templates select="tei:body/tei:div"/>
            </main>
            <script>
                // Function to check the URL hash and highlight the active letter
                function highlightActiveLetter() {
                const currentHash = window.location.hash;
                
                // First, remove the active class from all buttons
                document.querySelectorAll('.alpha-btn').forEach(btn => {
                btn.classList.remove('active');
                });
                
                // If there is a hash (e.g., "#a"), find the matching link and add the active class
                if (currentHash) {
                const activeLink = document.querySelector(`.alpha-btn[href="${currentHash}"]`);
                if (activeLink) {
                activeLink.classList.add('active');
                }
                }
                }
                
                // Function for the Clear button to remove the hash and reset the visual state
                function clearAlphabetFilter() {
                // Removes the #letter from the URL without reloading the page
                history.replaceState(null, null, ' ');
                // Run the highlighter function to clear the active visual state
                highlightActiveLetter();
                // Smoothly scroll back to the top of the alphabet container
                document.querySelector('.alphabet-container').scrollIntoView({ behavior: 'smooth' });
                }
                
                // Listen for whenever the user clicks a letter (hash changes)
                window.addEventListener('hashchange', highlightActiveLetter);
                
                // Run on page load in case someone visits the link with a hash already there
                window.addEventListener('DOMContentLoaded', highlightActiveLetter);
            </script>
        </body>
    </xsl:template>

    <!-- 
		 =======================================================
			structural elements in all documents-->

    <xsl:template match="tei:div">
        <div class="paratext">
            <h1>Biographies</h1>
            <p>These pages provide information about contemporaries to whom Southey was connected,
                in particular, correspondents, family and friends. </p>
            <p>Information about minor acquaintances and about contemporaries whom Southey did not
                meet or correspond with can be found in the editorial notes to individual
                letters.</p>
            <p><em id="dnb" style="font-weight: bold; color: #00347d">DNB</em> indicates that further information can be found in the new
                Oxford <em>Dictionary of National Biography</em>.</p>
            <p><em id="hp" style="font-weight: bold; color: #00347d">Hist P</em> indicates that further information can be found in <em>The
                    History of Parliament</em>. </p>
            <div class="alphabet-container">
                <a href="#a" class="alpha-btn">A</a>
                <a href="#b" class="alpha-btn">B</a>
                <a href="#c" class="alpha-btn">C</a>
                <a href="#d" class="alpha-btn">D</a>
                <a href="#e" class="alpha-btn">E</a>
                <a href="#f" class="alpha-btn">F</a>
                <a href="#g" class="alpha-btn">G</a>
                <a href="#h" class="alpha-btn">H</a>
                <a href="#i" class="alpha-btn">I</a>
                <a href="#j" class="alpha-btn">J</a>
                <a href="#k" class="alpha-btn">K</a>
                <a href="#l" class="alpha-btn">L</a>
                <a href="#m" class="alpha-btn">M</a>
                <a href="#n" class="alpha-btn">N</a>
                <a href="#o" class="alpha-btn">O</a>
                <a href="#p" class="alpha-btn">P</a>
                <a href="#q" class="alpha-btn">Q</a>
                <a href="#r" class="alpha-btn">R</a>
                <a href="#s" class="alpha-btn">S</a>
                <a href="#t" class="alpha-btn">T</a>
                <a href="#u" class="alpha-btn">U</a>
                <a href="#v" class="alpha-btn">V</a>
                <a href="#w" class="alpha-btn">W</a>
                <a href="#x" class="alpha-btn">X</a>
                <a href="#y" class="alpha-btn">Y</a>
                <a href="#z" class="alpha-btn">Z</a>
                <button class="alpha-btn clear-btn" onclick="clearAlphabetFilter()">Clear</button>
            </div>
            <xsl:apply-templates select="tei:listPerson"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:listPerson">
        <xsl:for-each-group select="tei:person" 
            group-by="upper-case(substring(my:get-sort-name(.), 1, 1))">
            
            <xsl:sort select="current-grouping-key()" order="ascending"/>
            
            <h2 id="{lower-case(current-grouping-key())}">
                <xsl:value-of select="upper-case(current-grouping-key())"/>
            </h2>
            
            <dl>
                <!-- Sort people within the group alphabetically by full sort name -->
                <xsl:apply-templates select="current-group()">
                    <xsl:sort select="my:get-sort-name(.)" order="ascending"/>
                </xsl:apply-templates>
            </dl>
            
            <p><em><a href="#top">Back to top</a></em></p>
            
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template match="tei:person">
        <xsl:apply-templates select="tei:persName"/>
        <xsl:apply-templates select="tei:note"/>
        <!-- birth, death, and bibl are brought into those two templates but otherwise should not print -->
    </xsl:template>

    <xsl:template match="tei:persName">
    <dt>
        <xsl:attribute name="id" select="@xml:id"/>
        <xsl:choose>
            <xsl:when test="tei:surname[@type='birth']">
                <xsl:value-of select="tei:surname[@type='married']"/>
                <xsl:text> (née </xsl:text>
                <xsl:value-of select="tei:surname[@type='birth']"/>
                <xsl:text>)</xsl:text>
                <xsl:choose>
                    <xsl:when test="tei:roleName or tei:forename">
                        <xsl:text>, </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text> </xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="tei:surname[@type='dynasty']"/>
            <xsl:otherwise>
                <xsl:value-of select="tei:surname"/>
                <xsl:if test="tei:forename or tei:roleName">
                <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="tei:forename">
                <xsl:apply-templates select="tei:forename"/>
                <xsl:if test="tei:roleName">
                    <xsl:text>, </xsl:text>
                </xsl:if>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="tei:roleName">
            <xsl:apply-templates select="tei:roleName"/>
        </xsl:if>
        <xsl:if test="tei:addName">
            <xsl:text> [also </xsl:text>
            <xsl:apply-templates select="tei:addName"/>
            <xsl:text>]</xsl:text>
        </xsl:if>
        <xsl:if test="parent::tei:person/tei:birth or parent::tei:person/tei:death or parent::tei:person/tei:floruit">
        <xsl:text> (</xsl:text>
        <xsl:choose>
            <xsl:when test="parent::tei:person/tei:floruit">
                <xsl:value-of select="parent::tei:person/tei:floruit"/>
            </xsl:when>
            <xsl:when test="parent::tei:person/tei:death">
                <xsl:value-of
                    select="parent::tei:person/tei:birth"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="parent::tei:person/tei:birth"/>
            </xsl:otherwise>
        </xsl:choose>
                <xsl:if test="parent::tei:person/tei:birth and parent::tei:person/tei:death">&#8211;</xsl:if>
            <xsl:value-of select="parent::tei:person/tei:death"/>
            <xsl:text>)&#x0A;</xsl:text>
        </xsl:if>
        <xsl:if test="parent::tei:person/tei:note[@type='idInfo']">
            <xsl:text> </xsl:text>
            <xsl:value-of select="parent::tei:person/tei:note[@type='idInfo']"/>
            <xsl:text>&#x0A;</xsl:text>
        </xsl:if>
    </dt>
</xsl:template>
    
    <xsl:template match="tei:addName">
        <xsl:apply-templates/>
        <xsl:if test="following-sibling::tei:addName">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:note">
        <xsl:choose>
            <xsl:when test="@type='idInfo'"/>
            <xsl:when test="@type='bio'">
                <dd>
                    <p><xsl:apply-templates/>
                        <xsl:if test="parent::tei:person/tei:bibl">
                            <xsl:text> See also </xsl:text>
                            <xsl:apply-templates select="parent::tei:person/tei:bibl"></xsl:apply-templates>
                        </xsl:if>
                    </p>
                </dd>
            </xsl:when>
        </xsl:choose>
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
                        <xsl:value-of select="concat('refPeople.', $refNo)"/>
                        <!--This is for staticSearch -->
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </a>
    </xsl:template>
    
    <xsl:template match="tei:hi">
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="@rend"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:emph">
        <em>
            <xsl:value-of select="."/>
        </em>
    </xsl:template>
    
    <xsl:template match="tei:title">
        <xsl:choose>
            <xsl:when test="@ref">
                <a href="{@ref}"><em><xsl:value-of select="."/></em></a>
            </xsl:when>
            <xsl:otherwise>
                <em><xsl:value-of select="."/></em>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
