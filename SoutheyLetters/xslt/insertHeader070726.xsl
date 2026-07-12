<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">
	<xsl:output method="xml" encoding="utf-8" indent="no"/>
	<xsl:strip-space elements="*"/>

	<xsl:variable name="part" select="list/@xml:id"/>

	<!-- for inserting header information -->
	<xsl:template match="/">
		<xsl:variable name="partNo">
			<xsl:choose>
				<xsl:when test="$part = 'Part_One'">
					<xsl:value-of select="1"/>
				</xsl:when>
				<xsl:when test="$part = 'Part_Two'">
					<xsl:value-of select="2"/>
				</xsl:when>
				<xsl:when test="$part = 'Part_Three'">
					<xsl:value-of select="3"/>
				</xsl:when>
				<xsl:when test="$part = 'Part_Four'">
					<xsl:value-of select="4"/>
				</xsl:when>
				<xsl:when test="$part = 'Part_Five'">
					<xsl:value-of select="5"/>
				</xsl:when>
				<xsl:when test="$part = 'Part_Six'">
					<xsl:value-of select="6"/>
				</xsl:when>
				<xsl:when test="$part = 'Part_Seven'">
					<xsl:value-of select="7"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<!-- comment out when running paratext list, and resave paratext list in new xml folder-->
		<xsl:result-document href="../../XMLnew/{$part}/runListPt.{$partNo}.xml">
			<list xml:id="{list/@xml:id}">
			<xsl:for-each select="list/item">
				<xsl:variable name="letCode" select="@code"/>
				<xsl:variable name="letNbr">
					<xsl:choose>
						<xsl:when test="contains($letCode, 'letterEEd.26.')">
							<xsl:value-of select="substring-before(substring-after($letCode, 'letterEEd.26.'), '.xml')"/>
						</xsl:when>
						<xsl:when test="contains($letCode, 'Southey')">
							<xsl:value-of select="substring-before($letCode, 'Southey.xml')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-before($letCode, '.xml')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="contains($letNbr, 'letterlist')">
						<item code="southey.{$letNbr}.xml"/>
					</xsl:when>
					<xsl:when test="contains($letNbr, 'Intro')">
						<item code="southey.{$letNbr}.xml"/>
					</xsl:when>
					<xsl:otherwise>
						<item code="southey.{$partNo}.{$letNbr}.xml"></item>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			</list>
		</xsl:result-document>
		<xsl:for-each select="list/item">
			<xsl:apply-templates select="document(@code)/tei:TEI">
				<xsl:with-param name="docID" select="@code"/>
			</xsl:apply-templates>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="tei:TEI">
		<xsl:param name="docID"/>
		<xsl:variable name="partNo">
			<xsl:choose>
				<xsl:when test="$part = 'Part_One'">
					<xsl:value-of select="1"/>
				</xsl:when>
				<xsl:when test="$part = 'Part_Two'">
					<xsl:value-of select="2"/>
				</xsl:when>
				<xsl:when test="$part = 'Part_Three'">
					<xsl:value-of select="3"/>
				</xsl:when>
				<xsl:when test="$part = 'Part_Four'">
					<xsl:value-of select="4"/>
				</xsl:when>
				<xsl:when test="$part = 'Part_Five'">
					<xsl:value-of select="5"/>
				</xsl:when>
				<xsl:when test="$part = 'Part_Six'">
					<xsl:value-of select="6"/>
				</xsl:when>
				<xsl:when test="$part = 'Part_Seven'">
					<xsl:value-of select="7"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="newID">
			<xsl:choose>
				<xsl:when
					test="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition']">
					<xsl:choose>
						<xsl:when
							test="contains(tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition'], 'letterEEd.26.new.')">
							<xsl:choose>
								<xsl:when
									test="contains(tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition'], 'letterlist')">
									<xsl:value-of
										select="concat('southey.', substring-after(tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition'], 'letterEEd.26.new.'))"
									/>
								</xsl:when>
								<xsl:when
									test="contains(tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition'], 'Intro')">
									<xsl:value-of
										select="concat('southey.', substring-after(tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition'], 'letterEEd.26.new.'))"
									/>
								</xsl:when>
								<xsl:when test="$partNo != ''">
									<xsl:value-of
										select="concat('southey.', $partNo, '.', substring-after(tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition'], 'letterEEd.26.new.'))"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="concat('southey.', substring-after(tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition'], 'letterEEd.26.new.'))"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when
							test="contains(tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition'], 'letterEEd.26.')">
							<xsl:choose>
								<xsl:when
									test="contains(tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition'], 'letterlist')">
									<xsl:value-of
										select="concat('southey.', substring-after(tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition'], 'letterEEd.26.'))"
									/>
								</xsl:when>
								<xsl:when
									test="contains(tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition'], 'Intro')">
									<xsl:value-of
										select="concat('southey.', substring-after(tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition'], 'letterEEd.26.'))"
									/>
								</xsl:when>
								<xsl:when test="$partNo != ''">
									<xsl:value-of
										select="concat('southey.', $partNo, '.', substring-after(tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition'], 'letterEEd.26.'))"
									/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of
										select="concat('southey.', substring-after(tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition'], 'letterEEd.26.'))"
									/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of
								select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type = 'edition']"
							/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="contains($docID, 'letterlist')">
							<xsl:value-of
								select="concat('southey.', substring-before($docID, '.xml'))"/>
						</xsl:when>
						<xsl:when test="contains($docID, 'Intro')">
							<xsl:value-of
								select="concat('southey.', substring-before($docID, '.xml'))"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of
								select="concat('southey.', $partNo, '.', substring-before($docID, 'Southey.xml'))"
							/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:result-document href="../../XMLnew/{$part}/{$newID}.xml"> <!--have to manually change to paratext from variable part, inexplicably -->
			<TEI xmlns="http://www.tei-c.org/ns/1.0">
				<teiHeader>
					<fileDesc>
						<titleStmt>
							<xsl:choose>
								<xsl:when
									test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct">
									<title type="main" level="a">
										<xsl:apply-templates
											select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:analytic/tei:title[1]"
										/>
									</title>
									<title type="sub" level="m">
										<xsl:value-of
											select="translate(tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:monogr/tei:title[1], '.', '')"
										/>
									</title>
								</xsl:when>
								<xsl:otherwise>
									<title type="main" level="a">
										<xsl:choose>
											<xsl:when
												test="tei:text/tei:body/tei:div[@type = 'paratext']">
												<xsl:value-of
												select="tei:text/tei:body/tei:div[@type = 'paratext']/tei:head"
												/>
											</xsl:when>
											<xsl:when
												test="tei:text/tei:body/tei:div[@type = 'introduction']"
												>Introduction</xsl:when>
											<xsl:otherwise>

												<xsl:value-of
												select="concat(normalize-space(substring-before(tei:text/tei:body/tei:div[1]/tei:head, tei:text/tei:body/tei:div[1]/tei:head/tei:date)), ' ', normalize-space(tei:text/tei:body/tei:div[1]/tei:head/tei:date))"
												/>
											</xsl:otherwise>
										</xsl:choose>
									</title>
									<title type="sub" level="m">
										<xsl:choose>
											<xsl:when test="$part != ''">
												<xsl:value-of
												select="concat('The Collected Letters of Robert Southey, Part ', substring-after($part, '_'))"
												/>
											</xsl:when>
											<xsl:otherwise>The Collected Letters of Robert Southey</xsl:otherwise>
										</xsl:choose>
									</title>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when
									test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct">
									<xsl:choose>
										<xsl:when
											test="contains(tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:analytic/tei:author[1], 'Southey')">
											<author role="primary" from="1774" to="1843">
												<persName ana="http://viaf.org/viaf/61576896">
												<forename>Robert</forename>
												<surname>Southey</surname>
												</persName>
											</author>
										</xsl:when>
										<xsl:when
											test="contains(tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:analytic/tei:author[2], 'Southey')">
											<author role="primary" from="1774" to="1843">
												<persName ana="http://viaf.org/viaf/61576896">
													<forename>Robert</forename>
													<surname>Southey</surname>
												</persName>
											</author>
										</xsl:when>
										<xsl:otherwise>
											<xsl:copy-of
												select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:analytic/tei:author"
											/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<author role="primary" from="1774" to="1843">
										<persName ana="http://viaf.org/viaf/61576896">
											<forename>Robert</forename>
											<surname>Southey</surname>
										</persName>
									</author>
								</xsl:otherwise>
							</xsl:choose>
							<editor>Lynda Pratt</editor>
							<respStmt>
								<resp>TEI Encoding</resp>
								<name>Averill Buchanan</name>
							</respStmt>
							<sponsor>Romantic Circles</sponsor>
							<respStmt>
								<resp>Director</resp>
								<name>Thora Brylowe</name>
							</respStmt>
							<respStmt>
								<resp>Technical Editor</resp>
								<name>Laura Mandell</name>
							</respStmt>
						</titleStmt>
						<editionStmt>
							<edition>
								<date>2026-07-20</date>
							</edition>
						</editionStmt>
						<publicationStmt>
							<publisher>Romantic Circles, https://romantic-circles.org, University of
								Colorado and Texas A&amp;M University</publisher>
							<pubPlace>College Station, TX</pubPlace>
							<availability status="free">
								<p>This document is made available via a Creative Commons Zero
									License, as described under "Conditions of Use" at
									http://romantic-circles.org/about/submission-guidelines and
									here:</p>
								<p>As of July 2027, all material published on Romantic Circles is
									licensed uder Creative Commons Zero (CC 0), unless otherwise
									noted.</p>
								<p>Unless otherwise noted, users are not permitted to download texts
									and images published before December 2023 in order to mount them
									on their own servers.</p>
							</availability>
							<idno type="edition">
								<xsl:value-of select="$newID"/>
							</idno>
						</publicationStmt>
						<sourceDesc>
							<xsl:choose>
								<xsl:when
									test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct">
									<xsl:for-each
										select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:p">
										<p>
											<xsl:copy select="@* | node()"/>
										</p>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when
											test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:p[2]">
											<xsl:for-each
												select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:p">
												<p>
												<xsl:copy select="@* | node()"/>
												</p>
											</xsl:for-each>
										</xsl:when>
										<xsl:when
											test="tei:text/tei:body/tei:div[1]/tei:head/tei:note">
											<p>
												<xsl:value-of
												select="tei:text/tei:body/tei:div[1]/tei:head/tei:note"
												/>
											</p>
										</xsl:when>
										<xsl:otherwise/>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
							<p>For permission to publish the text of MSS in their possession, the
								editor wishes to thank the Beinecke Rare Books and Manuscript
								Library, Yale University; Berg Collection of English and American
								Literature, The New York Public Library, Astor, Lenox and Tilden
								Foundations; the Bodleian Library Oxford University; the British
								Library; Boston Public Library; the Syndics of Cambridge University
								Library; the Syndics of the Fitzwilliam Museum Cambridge; Haverford
								College, Connecticut; the Historical Society of Pennsylvania; the
								Hornby Library, Liverpool Libraries and Information Services; the
								Houghton Library, Harvard University; the John Rylands Library,
								Manchester; the Kenneth Spencer Research Library, University of
								Kansas; Luton Museum (Bedfordshire County Council); Massachusetts
								Historical Society; McGill University Library; the National Library
								of Scotland; the Newberry Library, Chicago; the New York Public
								Library (Pforzheimer Collections); the Pierpont Morgan Library, New
								York; the Public Record Offices of Bedford, Suffolk (Bury St
								Edmunds) and Northumberland, the Master and Fellows of Trinity
								College, Cambridge; the Society of Antiquaries of Newcastle upon
								Tyne; the Trustees of the William Salt Library, Stafford, the
								Wisbech and Fenland Museum; the University of Virginia Library.</p>
							<p>A research grant from the British Academy made much of the archival
								work possible, as did support from the English Department of
								Nottingham Trent University.</p>

						</sourceDesc>
					</fileDesc>
					<encodingDesc>
						<editorialDecl>
							<quotation>
								<p>All quotation marks and apostrophes have been changed: " for “,"
									for ”, ' for ‘, and ' for ’.</p>
							</quotation>
							<hyphenation eol="none">
								<p>Any dashes occurring in line breaks have been removed.</p>
								<p>Because of web browser variability, all hyphens have been typed
									on the U.S. keyboard.</p>
								<p>Dashes have been rendered as a variable number of hyphens to give
									a more exact rendering of their length.</p>
							</hyphenation>
							<normalization method="markup">
								<p>Southey's spelling has not been regularized.</p>
								<p>Writing in other hands appearing on these manuscripts has been
									indicated as such, the content recorded in brackets.</p>
							</normalization>
							<normalization>
								<p>&amp; has been used for the ampersand sign.</p>
								<p>&#163; has been used for £, the pound sign</p>
								<p>All other characters, those with accents, non-breaking spaces,
									etc., have been encoded in HTML entity decimals.</p>
							</normalization>
						</editorialDecl>
						<classDecl>
							<taxonomy targetDatcat="https://viaf.org/">
								<bibl>VIAF</bibl>
								<category xml:id="viaf_61576896">
									<catDesc>Southey, Robert, 1774-1843</catDesc>
								</category>
								<category xml:id="viaf_118520952">
									<catDesc>Pratt, Lynda, 1964-</catDesc>
								</category>
								<category xml:id="viaf_116328125">
									<catDesc>Packer, Ian, 1962-</catDesc>
								</category>
								<category xml:id="viaf_18359329">
									<catDesc>Fulford, Tim, 1962-</catDesc>
								</category>
								<category xml:id="viaf_42171645">
									<catDesc>Bolton, Carol</catDesc>
								</category>
								<category xml:id="viaf_250654121">
									<catDesc>Buchanan, Averill</catDesc>
								</category>
								<category xml:id="viaf_41749340">
									<catDesc>Mandell, Laura, 1958-</catDesc>
								</category>
							</taxonomy>
							<taxonomy
								targetDatcat="https://www.wikidata.org/wiki/Wikidata:Main_Page">
								<bibl>Wikidata</bibl>
								<category xml:id="Q37068">
									<catDesc>Romanticism</catDesc>
								</category>
								<category xml:id="Q1277575">
									<catDesc>correspondence</catDesc>
								</category>
							</taxonomy>
							<taxonomy corresp="SoutheyLetters/XML/paratext/people.xml">
								<bibl>Southey Letters: Biographies</bibl>
							</taxonomy>
							<taxonomy corresp="SoutheyLetters/XML/paratext/places.xml">
								<bibl>Southey Letters: Places</bibl>
							</taxonomy>
						</classDecl>
					</encodingDesc>
					<profileDesc>
						<textClass>
							<catRef target="#Q1277575" scheme="Wikidata"/>
							<catRef target="#viaf_61576896" scheme="VIAF"/>
							<catRef target="#viaf_118520952" scheme="VIAF"/>
							<catRef target="#viaf_250654121" scheme="VIAF"/>
							<catRef target="#viaf_41749340" scheme="VIAF"/>
							<xsl:if test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:p[contains(., 'Ian Packer')] 
								or tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:analytic/tei:author[contains(., 'Ian Packer')] 
								or tei:text/tei:body/tei:div[1]/tei:head/tei:bibl/tei:author[contains(., 'Ian Packer')]">
								<catRef target="#viaf_116328125" scheme="VIAF"/>
							</xsl:if>
							<xsl:if test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:p[contains(., 'Tim Fulford')] 
								or tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:analytic/tei:author[contains(., 'Tim Fulford')] 
								or tei:text/tei:body/tei:div[1]/tei:head/tei:bibl/tei:author[contains(., 'Tim Fulford')]">
								<catRef target="#viaf_18359329" scheme="VIAF"/>
							</xsl:if>
							<xsl:if test="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:p[contains(., 'Carol Bolton')] 
								or tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblStruct/tei:analytic/tei:author[contains(., 'Carol Bolton')] 
								or tei:text/tei:body/tei:div[1]/tei:head/tei:bibl/tei:author[contains(., 'Carol Bolton')]">
								<catRef target="#viaf_42171645" scheme="VIAF"/>
							</xsl:if>
						</textClass>
					</profileDesc>
					<revisionDesc>
						<change when="2026-07-12" who="#LM">
							<label>Changed by</label>
							<name>Laura Mandell</name>
							<list>
								<item>Created new header for new edition edition XML from old
									edition XML dated <xsl:value-of
										select="tei:teiHeader/tei:fileDesc/tei:editionStmt/tei:edition/tei:date"
									/>. For the old header, see
									SoutheyLetters/XML/origHdr/origHdr.26.xml. </item>
							</list>
						</change>
						<xsl:if test="$partNo = '6'">
							<change when="2026-07-12" who="#LM">
								<label>Changed by</label>
								<name>Laura Mandell</name>
								<list>
									<item>Changed biblStruct/monogr/title[level='m'] from "Part Five" (erroneous) to "Part Six" (correct)</item>
								</list>
							</change>
						</xsl:if>
						<xsl:for-each select="tei:teiHeader/tei:revisionDesc/tei:change">
							<xsl:copy-of select="."/>
						</xsl:for-each>
					</revisionDesc>
				</teiHeader>
				<text>
					<xsl:copy-of select="tei:text/tei:body"/>
				</text>
			</TEI>
		</xsl:result-document>
	</xsl:template>

</xsl:stylesheet>
