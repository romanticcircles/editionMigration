<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei" version="3.0">

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

	<xsl:param name="nbrPoetryLines">no</xsl:param>
	<xsl:param name="css">../../css/southey.css</xsl:param>
	<xsl:key name="personLookup" match="person" use="@xml:id"/>
	<xsl:key name="placeLookup" match="place" use="@xml:id"/>

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="list">
		<xsl:for-each select="item">
			<xsl:apply-templates select="document(@code)/tei:TEI"/>
		</xsl:for-each>
	</xsl:template>


	<!-- =======================================================
		document structure -->

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
		<xsl:variable name="docID"
			select="tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition']"/>
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
								<xsl:value-of select="concat(tei:persName/tei:forename, ' ', tei:persName/tei:surname)"/>
									</xsl:attribute>
								</meta>
							</xsl:when>
							<xsl:otherwise>
								<meta name="author">
									<xsl:attribute name="content">
								<xsl:value-of
									select="normalize-space(.)"/>
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
										<xsl:value-of select="concat(tei:persName/tei:forename, ' ', tei:persName/tei:surname)"/>
									</xsl:attribute>
								</meta>
							</xsl:when>
							<xsl:otherwise>
								<meta name="docAuthor" class="staticSearch_docAuthor">
									<xsl:attribute name="content">
										<xsl:value-of
											select="normalize-space(.)"/>
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
			<link rel="stylesheet" type="text/css" href="{$css}"/>
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
				<xsl:apply-templates select="tei:body"/>
				<xsl:if test="//tei:note">
					<div class="notes">
						<h1>Notes</h1>
						<xsl:apply-templates select="//tei:note" mode="end"/>
					</div>
				</xsl:if>
			</main>
			<p class="noteSpace">&#160;</p>
		</body>
	</xsl:template>

	<!-- 
		 =======================================================
			structural elements in all documents-->

	<xsl:template match="tei:div">
		<xsl:variable name="docID"
			select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition']"/>
		<xsl:variable name="getPath">
			<xsl:value-of
				select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:editionStmt/tei:edition/@n"
			/>
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
		<div>
			<xsl:attribute name="class" select="@type"/>
			<xsl:attribute name="id">
				<xsl:choose>
					<xsl:when test="@xml:id">
						<xsl:value-of select="@xml:id"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$docID"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:if test="not(parent::tei:div)">
				<a href="../../XML/{$ptPath}/{$docID}.xml">
					<img src="../../images/TEI_Logo.png" alt="TEI logo" class="teiLogo"/>
				</a>
			</xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tei:div/tei:head">
		<h1>
			<xsl:apply-templates/>
		</h1>
	</xsl:template>

	<xsl:template match="tei:p">
		<p>
			<xsl:if test="@xml:id">
				<xsl:attribute name="id" select="@xml:id"/>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class">
						<xsl:value-of select="@rend"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="@type">
					<xsl:attribute name="class" select="@type"/>
				</xsl:when>
			</xsl:choose>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:lg">
		<p class="stanza">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:l">
		<xsl:variable name="lineNo">
			<xsl:number level="any"/>
		</xsl:variable>
		<span class="l" id="line{$lineNo}">
			<!-- id above for static search -->
			<xsl:choose>
				<xsl:when test="@rend">
					<span class="ltext {@rend}">
						<xsl:apply-templates/>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<span class="ltext">
						<xsl:apply-templates/>
					</span>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="$nbrPoetryLines = 'yes'">
				<span class="lno">
					<xsl:value-of select="$lineNo"/>
				</span>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="tei:table">
		<table>
			<xsl:if test="@rendition">
				<xsl:attribute name="class" select="substring-after(@rendition, '#')"/>
			</xsl:if>
			<xsl:apply-templates/>
		</table>
	</xsl:template>

	<xsl:template match="tei:row">
		<tr>
			<xsl:if test="@rendition">
				<xsl:attribute name="class" select="substring-after(@rendition, '#')"/>
			</xsl:if>
			<xsl:apply-templates/>
		</tr>
	</xsl:template>

	<xsl:template match="tei:cell">
		<td>
			<xsl:if test="@rendition">
				<xsl:attribute name="class" select="substring-after(@rendition, '#')"/>
			</xsl:if>
			<xsl:apply-templates/>
		</td>
	</xsl:template>

	<xsl:template match="tei:lb">
		<xsl:choose>
			<xsl:when test="preceding-sibling::tei:lg[1]"/>
			<xsl:otherwise>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:list">
		<xsl:choose>
			<xsl:when test="@type = 'gloss'">
				<dl>
					<xsl:apply-templates/>
				</dl>
			</xsl:when>
			<xsl:otherwise>
				<ul>
					<xsl:apply-templates/>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:item">
		<xsl:choose>
			<xsl:when test="parent::tei:list[@type = 'gloss']">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<li>
					<xsl:apply-templates/>
				</li>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:term">
		<dt>
			<xsl:attribute name="id" select="@xml:id"/>
			<xsl:apply-templates/>
		</dt>
	</xsl:template>

	<xsl:template match="tei:gloss">
		<dd>
			<xsl:apply-templates/>
		</dd>
	</xsl:template>

	<xsl:template match="tei:label">
		<span class="label">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<!-- links -->

	<xsl:template match="tei:ref">
		<xsl:variable name="docID"
			select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition']"/>
		<xsl:variable name="refNo">
			<xsl:number select="." level="any"/>
			<!--This is for staticSearch -->
		</xsl:variable>
		<xsl:variable name="letNBR">
			<xsl:value-of select="substring-after($docID, 'southey.')"/>
			<!--This is for staticSearch -->
		</xsl:variable>
		<xsl:variable name="urlLocal" select="@target"/>
		<xsl:choose>
			<xsl:when test="contains($urlLocal, 'people')">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat('../paratext/', @target)"/>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:value-of select="concat('ref', $letNBR, '.', $refNo)"/>
						<!--This is for staticSearch -->
					</xsl:attribute>
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:when test="contains($urlLocal, 'places')">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat('../paratext/', @target)"/>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:value-of select="concat('ref', $letNBR, '.', $refNo)"/>
						<!--This is for staticSearch -->
					</xsl:attribute>
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:when test="contains($urlLocal, 'corresp')">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat('../paratext/', @target)"/>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:value-of select="concat('ref', $letNBR, '.', $refNo)"/>
						<!--This is for staticSearch -->
					</xsl:attribute>
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="@target"/>
					</xsl:attribute>
					<xsl:attribute name="id">
						<xsl:value-of select="concat('ref', $letNBR, '.', $refNo)"/>
						<!--This is for staticSearch -->
					</xsl:attribute>
					<xsl:apply-templates/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!-- =======================================================
		   style -->

	<xsl:template match="tei:hi">
		<span>
			<xsl:attribute name="class">
				<xsl:value-of select="@rend"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:emph">
		<span class="emphasis">
			<xsl:value-of select="."/>
		</span>
	</xsl:template>

	<xsl:template match="tei:title">
		<span class="title">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<tei:template match="tei:text//*/tei:label">
		<span class="label">
			<xsl:apply-templates/>
		</span>
	</tei:template>


	<!-- =======================================================
		figures, images, and illustrations -->

	<xsl:template match="tei:figure">
		<figure>
			<xsl:attribute name="class" select="@type"/>
			<xsl:apply-templates select="tei:head"/>
			<xsl:apply-templates select="tei:graphic"/>
			<figcaption>
				<xsl:apply-templates select="tei:figDesc"/>
			</figcaption>
		</figure>
	</xsl:template>

	<xsl:template match="tei:figure/tei:head">
		<header>
			<span class="figureHead">
				<xsl:apply-templates/>
			</span>
		</header>
	</xsl:template>

	<xsl:template match="tei:graphic">
		<a target="_blank">
			<xsl:attribute name="href">
				<xsl:value-of select="@url"/>
			</xsl:attribute>
			<img>
				<xsl:attribute name="src">
					<xsl:value-of select="@url"/>
				</xsl:attribute>
				<xsl:attribute name="alt">
					<xsl:value-of select="parent::tei:figure/tei:head"/>
				</xsl:attribute>
				<xsl:attribute name="class">
					<xsl:value-of select="parent::tei:figure/@type"/>
				</xsl:attribute>
			</img>
		</a>
	</xsl:template>


	<!-- =======================================================
	      quotations -->

	<xsl:template match="tei:q">
		<xsl:text>&quot;</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>&quot;</xsl:text>
	</xsl:template>

	<xsl:template match="tei:quote">
		<xsl:choose>
			<xsl:when test="parent::tei:div">
				<div class="blockquote">
					<xsl:apply-templates/>
				</div>
			</xsl:when>
			<xsl:when test="parent::tei:p">
				<span class="blockquote">
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<p class="blockquote">
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:epigraph">
		<xsl:choose>
			<xsl:when test="tei:p or tei:lg">
				<div class="blockquote">
					<xsl:apply-templates/>
				</div>
			</xsl:when>
			<xsl:when test="parent::tei:div">
				<div class="blockquote">
					<xsl:apply-templates/>
				</div>
			</xsl:when>
			<xsl:when test="tei:l">
				<p class="blockquote stanza">
					<xsl:apply-templates/>
				</p>
			</xsl:when>
			<xsl:when test="parent::tei:p">
				<span class="blockquote">
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<p class="blockquote">
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--  =======================================================
		corrections and deletions -->

	<xsl:template match="tei:add">
		<xsl:choose>
			<xsl:when test="contains(., 'x') or contains(., 'X')">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:otherwise>
				<span class="addUP">
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:del">
				<span class="del">
					<xsl:apply-templates/>
				</span>
	</xsl:template>

	<xsl:template match="tei:unclear"> [unclear:][<xsl:apply-templates/>] </xsl:template>


	<!-- =======================================================
	   letters -->

	<xsl:template match="tei:date">
		<xsl:text> </xsl:text>
		<span class="date">
			<xsl:apply-templates/>
		</span>
	</xsl:template>


	<xsl:template match="tei:opener">
		<p>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class">
						<xsl:value-of select="concat('opener ', @rend)"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class" select="'opener'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:closer">
		<p>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class">
						<xsl:value-of select="concat('closer ', @rend)"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class" select="'closer'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template
		match="tei:dateline | tei:address | tei:addrLine | tei:placeName | tei:salute | tei:signed | tei:time">
		<span>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class">
						<xsl:value-of select="concat(local-name(), ' ', @rend)"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">
						<xsl:value-of select="local-name()"/>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</span>
	</xsl:template>


	<!-- =======================================================
	   notes and backmatter -->

	<xsl:template match="tei:note">
		<xsl:variable name="rawNoteNbr">
			<xsl:number select="." level="any"/>
		</xsl:variable>
		<xsl:variable name="noteNumber">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div/@type = 'letter'">
					<xsl:value-of select="number($rawNoteNbr) - 1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$rawNoteNbr"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="@type = 'headnote'">
				<a href="#headnote" id="Bheadnote">
						<xsl:text>*</xsl:text>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:attribute name="href">
						<xsl:text>#</xsl:text>
						<xsl:value-of select="@n"/>
					</xsl:attribute>
					<xsl:attribute name="id" select="concat('back', $noteNumber)"/>
					<sup>
						<xsl:value-of select="@n"/>
					</sup>
				</a>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:note" mode="end">
		<xsl:variable name="rawNoteNbr">
			<xsl:number select="." level="any"/>
		</xsl:variable>
		<xsl:variable name="noteNumber">
			<xsl:choose>
				<xsl:when test="ancestor-or-self::tei:TEI/tei:text/tei:body/tei:div/@type = 'letter'">
					<xsl:value-of select="number($rawNoteNbr) - 1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$rawNoteNbr"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="@type = 'headnote'">
				<p id="headnote">
					<xsl:apply-templates/>
					<xsl:text> </xsl:text>
					<a href="#Bheadnote">
						<xsl:text>Back</xsl:text>
					</a>
				</p>
			</xsl:when>
			<xsl:when test="tei:p or tei:lg">
				<div class="note" id="{$noteNumber}">
					<xsl:value-of select="$noteNumber"/>
					<xsl:text>.&#160;&#160;</xsl:text>
					<xsl:apply-templates/>
					<xsl:text> </xsl:text>
					<a>
						<xsl:attribute name="href">
							<xsl:text>#back</xsl:text>
							<xsl:value-of select="$noteNumber"/>
						</xsl:attribute>
						<xsl:text>Back</xsl:text>
					</a>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<p class="note" id="{$noteNumber}">
					<xsl:value-of select="$noteNumber"/>
					<xsl:text>.&#160;&#160;</xsl:text>
					<xsl:apply-templates/>
					<xsl:text> </xsl:text>
					<a>
						<xsl:attribute name="href">
							<xsl:text>#back</xsl:text>
							<xsl:value-of select="$noteNumber"/>
						</xsl:attribute>
						<xsl:text>Back</xsl:text>
					</a>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
