<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei" version="2.0">
	<xsl:output method="xhtml" omit-xml-declaration="no" encoding="UTF-8"/>
	<xsl:strip-space elements="*"/>

	<!--  =======================================================
		revision history
	00-began with fork from /xslt/masters/HTMLtransform.xsl
	01-filled master with needed code
	02-revised plays, simplified by eliminating TOC
	03-created for CritArchive 
	04-changes 09/20/2021
	05-new, combining LL, LM, and SN, as of 8/24/22
	06-revised for P4H Fall 2022, as of 11/18/22
	07-revised for staticSearch (Leapor) 12/30/24
	07-revised LBs (Graver) 7/25 -->


	<!-- =======================================================
		sections in this xslt:
		
		1.  running documents
		2.  document structure
		3.  front templates
		4.  structural elements all documents
		5.  style
		6.  figures, images, illustrations
		7.  bibliographic and quotations
		8.  page numbers and forme work
		9.  drama
		10. letters
		11. notes and back matter
	
	-->

	<!-- One brute force correction: to the html output of LB00-2y.xml, in The Brothers, line 324,
		I have to add to the ItemAR style="margin-left: -4rem" because god knows why it appears 
		differently from all the others....-->

	<!-- =======================================================
		running documents -->

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
		<xsl:variable name="docID">
			<xsl:value-of
				select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'local']"/>
		</xsl:variable>
		<xsl:result-document href="../HTML/{$docID}.html">
			<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
			<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
				<xsl:comment>This XHTML 5 page is generated from a TEI Master; do not edit.</xsl:comment>
				<xsl:apply-templates/>
			</html>
		</xsl:result-document>
	</xsl:template>

	<xsl:template match="tei:teiHeader">
		<xsl:variable name="docID">
			<xsl:value-of
				select="tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'local']"/>
		</xsl:variable>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
			<title>
				<xsl:value-of select="tei:fileDesc/tei:titleStmt/tei:title[1]"/>
			</title>
			<link rel="stylesheet" type="text/css" href="../css/LBstyle.css"/>
			<xsl:if test="$docID = 'LB00-1a'">
			<script src="../js/showChange2.js"/>
			</xsl:if>
			<link rel="preconnect" href="https://fonts.googleapis.com"/>
			<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous"/>
			<!-- according to Claude, what Google Fonts API expects -->
			<link
				href="https://fonts.googleapis.com/css2?family=Edu+NSW+ACT+Cursive:wght@400..700&amp;display=swap"
				rel="stylesheet"/>
		</head>
	</xsl:template>

	<xsl:template match="tei:TEI/tei:text">
		<body>
			<!--added the choose -->
			<xsl:choose>
				<xsl:when test="//tei:add[@place = 'lmargin'] or //tei:add[@place = 'rmargin']">
					<div class="wrapperCorr">
						<xsl:apply-templates/>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
			<!--<script> This script is for LB00-1_wImg.xml to .html
				document.addEventListener("DOMContentLoaded", () => {
				const OFFSET_X = 50; // adjust how far to the right
				const OFFSET_Y = 0;  // adjust how far down
				
				document.querySelectorAll(".popup-link").forEach(link => {
				link.addEventListener("click", e => {
				e.preventDefault();
				
				const rect = link.getBoundingClientRect();
				const left = rect.right + window.screenX + OFFSET_X;
				const top = rect.top + window.screenY + OFFSET_Y;
				
				window.open(
				link.href,
				"_blank",
				`width=600,height=900,left=${left},top=${top}`
				);
				});
				});
				});
			</script> -->
		</body>
	</xsl:template>

	<xsl:template match="tei:group/tei:text">
		<xsl:if test="tei:front">
			<xsl:apply-templates select="tei:front"/>
		</xsl:if>
		<xsl:apply-templates select="tei:body"/>
		<xsl:if test="tei:back">
			<xsl:apply-templates select="tei:back"/>
		</xsl:if>
	</xsl:template>

	<!-- =======================================================
	   front templates -->

	<xsl:template match="tei:front">
		<xsl:variable name="item">
			<xsl:value-of
				select="concat(//tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'local'], '_', @xml:id)"
			/>
		</xsl:variable>
		<div class="front" id="{$item}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tei:titlePage">
		<div class="tp">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tei:titlePart">
		<h2 class="tp">
			<xsl:apply-templates/>
		</h2>
	</xsl:template>
	<xsl:template match="tei:byline">
		<span class="byline">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:docAuthor">
		<h3 class="tp">
			<xsl:apply-templates/>
		</h3>
	</xsl:template>

	<xsl:template match="tei:docDate">
		<span class="tpDate">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:pubPlace">
		<span class="tpPlace">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:publisher">
		<span class="tpPub">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="tei:imprimatur">
		<span class="tpImprimatur">
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="tei:docImprint">
		<p class="noindent tpPubInfo">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:docEdition">
		<xsl:choose>
			<xsl:when test="tei:bibl/tei:biblScope/@unit">
				<p>
					<xsl:text>Vol. </xsl:text>
					<xsl:value-of select="tei:bibl/tei:biblScope[@unit = 'volume']"/>
					<xsl:text>, </xsl:text>
					<xsl:text>pp. </xsl:text>
					<xsl:value-of select="tei:bibl/tei:biblScope[@unit = 'page']"/>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<p class="tp">
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:argument">
		<div class="argument">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<!-- 
		 =======================================================
			structural elements all documents-->

	<xsl:template match="tei:group/tei:text/tei:body">
		<xsl:variable name="item">
			<xsl:value-of
				select="concat(ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'local'], '_', @xml:id)"
			/>
		</xsl:variable>
		<div class="item" id="{$item}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tei:div | tei:div1 | tei:div2">
		<div>
			<xsl:if test="@type">
				<xsl:attribute name="class" select="@type"/>
			</xsl:if>
			<xsl:if test="@xml:id">
				<xsl:attribute name="id" select="@xml:id"/>
			</xsl:if>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tei:head">
		<xsl:choose>
			<xsl:when test="parent::tei:body[@xml:id = 'pubAdvert']">
				<h4>
					<xsl:apply-templates/>
				</h4>
			</xsl:when>
			<xsl:otherwise>
				<header>
					<xsl:apply-templates/>
				</header>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- this means that the paragraph in the main html document where you want another version to popup
		has xml:id [whatever-code begins Cancel and Change in the other xml:ids (LB00-1a, it's 'a3')]orig. 
		See the wordDoc "cancel" for instructions for properly encoding the TEI.-->
	<xsl:template match="tei:p">
		<xsl:variable name="linkID">
			<xsl:value-of select="substring-before(@xml:id, 'orig')"/>
		</xsl:variable>
		<xsl:variable name="changeLink">
			<xsl:value-of select="concat('#', $linkID, 'Change')"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains(@xml:id, 'orig')">
				<a href="#" onclick="openChangeInPopup(event, '{$changeLink}')">
					<img src="../images/edIcon.png" alt="View Change" class="popupIcon"/>
				</a>
			</xsl:when>
		</xsl:choose>
		<p>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class">
						<xsl:value-of select="@rend"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="@type">
					<xsl:attribute name="class" select="@type"/>
				</xsl:when>
				<xsl:when test="@xml:id">
					<xsl:attribute name="id" select="@xml:id"/>
				</xsl:when>
			</xsl:choose>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:q">
		<xsl:choose>
			<xsl:when test="parent::tei:p">
				<span class="blockquote">
					<xsl:apply-templates/>
				</span>
				<br/>
			</xsl:when>
			<xsl:otherwise>
				<blockquote>
					<xsl:apply-templates/>
				</blockquote>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:lg">
		<xsl:if test="@n">
			<span class="stzNbr">
				<xsl:value-of select="@n"/>
			</span>
		</xsl:if>
		<xsl:choose>
			<!-- this is what I changed in order to produce valid html, I added the "or" clause; 7/23/2025. -->
			<xsl:when test="parent::tei:p or parent::tei:q/parent::tei:p">
				<span>
					<xsl:choose>
						<xsl:when test="@type">
							<xsl:attribute name="class" select="@type"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">
								<xsl:text>verse</xsl:text>
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="tei:label">
						<span class="stanzaHeader">
							<xsl:apply-templates select="tei:label"/>
						</span>
					</xsl:if>
					<xsl:apply-templates select="tei:l | tei:pb | tei:milestone | tei:note"/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<p>
					<xsl:choose>
						<xsl:when test="@type">
							<xsl:attribute name="class" select="@type"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">
								<xsl:text>verse</xsl:text>
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="tei:label">
						<span class="stanzaHeader">
							<xsl:apply-templates select="tei:label"/>
						</span>
					</xsl:if>
					<xsl:apply-templates select="tei:l | tei:pb | tei:milestone | tei:note"/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:l">
		<xsl:variable name="class">
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:value-of select="concat('ltext ', @rend)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'ltext'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="@n">
				<span class="l">
					<span class="{$class}">
						<xsl:apply-templates/>
					</span>
					<span class="lno">
						<xsl:value-of select="@n"/>
					</span>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="l">
					<span class="{$class}">
						<xsl:apply-templates/>
					</span>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:del">
		<span class="del">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:add">
		<!-- added a bunch here -->
		<xsl:variable name="who">
			<xsl:if test="@hand">
				<xsl:value-of select="'addHand'"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="where">
			<if test="@place">
				<xsl:choose>
					<xsl:when test="@place = 'lmargin'">
						<xsl:text>itemAL</xsl:text>
					</xsl:when>
					<xsl:when test="@place = 'rmargin'">
						<xsl:text>itemAR</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@place"/>
					</xsl:otherwise>
				</xsl:choose>
			</if>
		</xsl:variable>
		<span>
			<xsl:if test="$who != '' and $where != ''">
				<xsl:attribute name="class">
					<xsl:value-of select="concat($who, ' ', $where)"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="$who != '' and $where = ''">
				<xsl:attribute name="class" select="$who"/>
			</xsl:if>
			<xsl:if test="$who = '' and $where != ''">
				<xsl:attribute name="class" select="$where"/>
			</xsl:if>
			<xsl:apply-templates/>
			<xsl:if test="@hand">
				<sup>
					<xsl:value-of select="@hand"/>
				</sup>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="tei:lb">
		<xsl:choose>
			<xsl:when test="@rend = 'hr'">
				<hr>
					<xsl:attribute name="class">
						<xsl:value-of select="parent::*/local-name()"/>
					</xsl:attribute>
				</hr>
			</xsl:when>
			<xsl:otherwise>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:list">
		<ul>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>

	<xsl:template match="tei:item">
		<li>
			<xsl:apply-templates/>
		</li>
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

	<xsl:template match="tei:ref">
		<xsl:variable name="docID">
			<xsl:value-of
				select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'local']"
			/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="@type = 'endnote'">
				<xsl:choose>
					<xsl:when test="@target = '#NOTESbro' or @target = '#NOTESmich'">
						<span class="sup">
							<a>
								<xsl:attribute name="href">
									<xsl:value-of
										select="concat('#', $docID, '_', substring-after(@target, '#'))"
									/>
								</xsl:attribute>
								<xsl:apply-templates/>
							</a>
						</span>
					</xsl:when>
					<xsl:otherwise>
						<span class="sup">
							<a href="{@target}">
								<xsl:apply-templates/>
							</a>
						</span>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:when>
			<xsl:otherwise>
				<a href="{@target}">
					<xsl:apply-templates/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:anchor">
		<a name="{@xml:id}"/>
	</xsl:template>

	<xsl:template match="tei:trailer">
		<p class="trailer">
			<xsl:apply-templates/>
		</p>
	</xsl:template>


	<!-- =======================================================
		   style -->

	<xsl:template match="tei:hi">
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
				<span class="smcaps">
					<xsl:apply-templates/>
				</span>
				<!--judging from the first LB98 -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:emph">
		<em>
			<xsl:apply-templates/>
		</em>
	</xsl:template>

	<xsl:template match="tei:orig">
		<xsl:choose>
			<xsl:when test="text() = 'ss'">
				<xsl:text>&#383;s</xsl:text>
			</xsl:when>
			<xsl:when test="@rend = 'long s' or text() = 's'">
				<xsl:text>&#383;</xsl:text>
			</xsl:when>
		</xsl:choose>

	</xsl:template>

	<!-- =======================================================
		figures, images, and illustrations -->

	<xsl:template match="tei:figure">
		<figure>
			<xsl:attribute name="class" select="@type"/>
			<xsl:apply-templates select="tei:head"/>
			<xsl:apply-templates select="tei:graphic"/>
			<xsl:if test="tei:figDesc">
				<figcaption>
					<xsl:apply-templates select="tei:figDesc"/>
				</figcaption>
			</xsl:if>
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
		<img>
			<xsl:attribute name="src">
				<xsl:value-of select="@url"/>
			</xsl:attribute>
			<xsl:attribute name="alt">
				<xsl:choose>
					<xsl:when test="parent::tei:figure/tei:head">
						<xsl:value-of select="parent::tei:figure/tei:head"/>
					</xsl:when>
					<xsl:when test="parent::tei:figure/tei:figDesc">
						<xsl:value-of select="parent::tei:figure/tei:figDesc"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>decorative</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</img>
	</xsl:template>


	<!-- =======================================================
	      bibliographic and quotations -->

	<xsl:template match="tei:epigraph">
		<div class="epigraph noindent">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<!--persons and places: templates pending -->

	<xsl:template match="tei:date">
		<span class="date">
			<xsl:apply-templates/>
		</span>
	</xsl:template>


	<!-- =======================================================
	   letters -->

	<xsl:template match="tei:opener">
		<p>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class">
						<xsl:value-of select="'opener'"/>
						<xsl:text>&#160;</xsl:text>
						<xsl:attribute name="class" select="@rend"/>
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
						<xsl:value-of select="'closer'"/>
						<xsl:text>&#160;</xsl:text>
						<xsl:attribute name="class" select="@rend"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class" select="'closer'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:salute | tei:signed">
		<span>
			<xsl:attribute name="class">
				<xsl:value-of select="local-name()"/>
				<xsl:if test="@rend">
					<xsl:text>&#160;</xsl:text>
					<xsl:value-of select="@rend"/>
				</xsl:if>
			</xsl:attribute>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="dateline">
		<p class="dateline">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="address">
		<span class="address">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="addrLine">
		<span>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class" select="@rend"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class" select="'addrLine'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="addName">
		<span>
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:attribute name="class" select="@rend"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class" select="'addName'"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<!-- ======================================================+
            templates used for drama -->


	<xsl:template match="tei:set">
		<div class="set">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tei:prologue | tei:epilogue">
		<div class="{local-name()}">
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<xsl:template match="tei:castList">
		<div class="castList">
			<xsl:if test="tei:head">
				<h5 class="castListHead">
					<xsl:value-of select="tei:head"/>
				</h5>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="//tei:castGroup/tei:castGroup">
					<xsl:apply-templates select="tei:castGroup | tei:castItem"/>
				</xsl:when>
				<xsl:otherwise>
					<table class="simpleCastList">
						<xsl:apply-templates select="tei:castItem" mode="simple"/>
					</table>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="tei:castGroup">
		<xsl:choose>
			<xsl:when test="parent::tei:castList">
				<ul>
					<li>
						<xsl:apply-templates/>
					</li>
				</ul>
			</xsl:when>
			<xsl:when test="child::tei:roleDesc">
				<table class="castGroupings">
					<tr>
						<td class="castItem">
							<xsl:apply-templates select="tei:castItem"/>
						</td>
						<xsl:choose>
							<xsl:when test="@rend = 'braced'">
								<td class="curlyBracket">}</td>
							</xsl:when>
							<xsl:otherwise>
								<td class="space">&#160;</td>
							</xsl:otherwise>
						</xsl:choose>
						<td class="roleDesc">
							<xsl:apply-templates select="tei:roleDesc"/>
						</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:castItem">
		<xsl:choose>
			<xsl:when
				test="parent::tei:castGroup and following-sibling::tei:roleDesc and child::tei:roleDesc">
				<table class="castItems">
					<tr>
						<td class="role">
							<xsl:apply-templates select="tei:role"/>
							<xsl:text>&#160;</xsl:text>
							<xsl:apply-templates select="tei:roleDesc"/>
						</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:when test="tei:role">
				<table class="castItems">
					<tr>
						<td class="role">
							<xsl:apply-templates select="tei:role"/>
						</td>
						<td class="space">&#160;</td>
						<xsl:choose>
							<xsl:when test="tei:roleDesc">
								<td class="itemRoleDesc">
									<xsl:apply-templates select="tei:roleDesc"/>
								</td>
							</xsl:when>
							<xsl:otherwise>
								<td class="space">&#160;</td>
							</xsl:otherwise>
						</xsl:choose>
					</tr>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<p class="castItem">
					<xsl:apply-templates/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:castItem" mode="simple">
		<tr>
			<td class="role">
				<xsl:apply-templates select="tei:role"/>
			</td>
			<td class="roleDesc">
				<xsl:apply-templates select="tei:roleDesc"/>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="tei:castGroup/tei:head">
		<span class="groupHead">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="tei:stage">
		<span>
			<xsl:attribute name="class">
				<xsl:text>stage </xsl:text>
				<xsl:value-of select="@type"/>
			</xsl:attribute>
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


	<!-- =======================================================
		page numbers and forme work -->

	<xsl:template match="tei:pb">
		<span class="newPage">
			<xsl:if test="@xml:id">
				<a name="{@xml:id}"/>
			</xsl:if>
			<xsl:if test="@facs">
				<xsl:attribute name="id">
					<xsl:value-of select="@facs"/>
				</xsl:attribute>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="tei:milestone">
		<xsl:choose>
			<xsl:when test="@unit = 'page' or @unit = 'pagenumber'">
				<span class="pageTopCenter">
					<xsl:value-of select="@n"/>
				</span>
			</xsl:when>
			<xsl:when test="@unit = 'runningHead'">
				<span class="runHead">
					<xsl:value-of select="@n"/>
				</span>
			</xsl:when>
		</xsl:choose>
	</xsl:template>


	<!-- =======================================================
	   notes -->

	<xsl:template match="tei:note">
		<xsl:variable name="docID">
			<xsl:value-of
				select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'local']"
			/>
		</xsl:variable>
		<xsl:variable name="noteClass">
			<xsl:choose>
				<xsl:when test="@rend">
					<xsl:value-of select="@rend"/>
				</xsl:when>
				<xsl:when test="@place = 'head'">
					<xsl:text>headnote</xsl:text>
				</xsl:when>
				<xsl:when test="@place = 'foot'">
					<xsl:text>footnote</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>note</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<span class="{$noteClass}">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

</xsl:stylesheet>
