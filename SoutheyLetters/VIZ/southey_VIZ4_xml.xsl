<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
	xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">
	<xsl:output omit-xml-declaration="no" method="xml" encoding="utf-8" indent="yes"/>
	<xsl:strip-space elements="*"/>

	<!-- global variables -->
	<xsl:variable name="newline">
		<xsl:text>&#10;</xsl:text>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:result-document href="southey_VIZ{Southey/@n}.xml">
			<xsl:value-of select="$newline"/>
			<viz>
			<xsl:for-each select="Southey/letter">
				<xsl:apply-templates select="document(@code)/tei:TEI">
					<xsl:with-param name="idno" select="@code"/>
				</xsl:apply-templates>
			</xsl:for-each>
			</viz>
		</xsl:result-document>
	</xsl:template>

	<xsl:template match="tei:TEI">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:teiHeader"/>

	<xsl:template match="tei:text">
		<xsl:apply-templates select="tei:body/tei:div[@type='letter']"/>
	</xsl:template>

	<xsl:template match="tei:div[@type='letter']">
		<xsl:variable name="addresseeID">
			<xsl:value-of select="tei:head/tei:ref[@type='a'][1]/@target"/>
		</xsl:variable>
		<xsl:variable name="addressee">
			<xsl:call-template name="lookUpName">
				<xsl:with-param name="nameCode"
					select="substring-after(tei:head/tei:ref[@type='a'][1]/@target, 'people.html#')"
				/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="addressee2id">
			<xsl:if test="tei:head/tei:ref[@type='a'][2]">
				<xsl:value-of select="tei:head/tei:ref[@type='a'][2]/@target"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="addressee2">
			<xsl:if test="tei:head/tei:ref[@type='a'][2]">
				<xsl:call-template name="lookUpName">
					<xsl:with-param name="nameCode"
						select="substring-after(tei:head/tei:ref[@type='a'][2]/@target, 'people.html#')"
					/>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>
		<xsl:for-each select="//tei:ref">
			<xsl:choose>
				<xsl:when test="@type='c'"/>
				<xsl:when test="@type='s'"/>
				<xsl:when test="contains(@target, 'places.html')"/>
				<xsl:when test="contains(@target, 'people.html')">
					<xsl:choose>
						<xsl:when test=".[@type='a']">
							<xsl:choose>
								<xsl:when test="$addressee2id = '' and not(following::tei:ref[@type='m'])">
									<!-- now we know that we have ONLY one addressee and no one mentioned in the letter -->
										<xsl:value-of select="$newline"/>
									<addressee>
										<xsl:value-of select="$newline"/>
										<name>
											<xsl:attribute name="id">
												<xsl:value-of select="substring-after($addresseeID, 'people.html#')"/>
											</xsl:attribute>
											<xsl:value-of select="$addressee"/>
										</name>
										<xsl:value-of select="$newline"/>
										<edge>
											<xsl:attribute name="letter">
												<xsl:value-of
												select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='edition']"
												/>
											</xsl:attribute>
										</edge>
									</addressee>
									<xsl:value-of select="$newline"/>
								</xsl:when>
								<xsl:when test="not(following::tei:ref[@type='m'])">
									<!-- now we know that there are two, because it wasn't stopped by the empty addressee above, and there are no mentions in the letter -->
									<xsl:value-of select="$newline"/>
									<addressee>
										<xsl:value-of select="$newline"/>
										<name>
											<xsl:attribute name="id">
												<xsl:value-of
												select="substring-after($addresseeID, 'people.html#')"
												/>
											</xsl:attribute>
											<xsl:value-of select="$addressee"/>
										</name>
										<xsl:value-of select="$newline"/>
										<edge>
											<xsl:attribute name="letter">
												<xsl:value-of
												select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='edition']"
												/>
											</xsl:attribute>
										</edge>
									</addressee>
									<xsl:value-of select="$newline"/>
									<addressee>
										<xsl:value-of select="$newline"/>
										<name>
											<xsl:attribute name="id">
												<xsl:value-of
												select="substring-after($addressee2id, 'people.html#')"
												/>
											</xsl:attribute>
											<xsl:value-of select="$addressee2"/>
										</name>
										<xsl:value-of select="$newline"/>
										<edge>
											<xsl:attribute name="letter">
												<xsl:value-of
												select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='edition']"
												/>
											</xsl:attribute>
										</edge>
									</addressee>
									<xsl:value-of select="$newline"/>
								</xsl:when>
							</xsl:choose>
							<!-- we want nothing to happen if people ARE mentioned in the letter, because the addressee's name will appear, per below, with each ref tag, each time someone is mentioned -->
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$newline"/>
							<addressee>
								<xsl:value-of select="$newline"/>
								<name>
									<xsl:attribute name="id">
										<xsl:value-of
											select="substring-after($addresseeID, 'people.html#')"/>
									</xsl:attribute>
									<xsl:value-of select="$addressee"/>
								</name>
								<xsl:value-of select="$newline"/>
								<edge>
									<xsl:attribute name="letter">
										<xsl:value-of
											select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='edition']"
										/>
									</xsl:attribute>
								</edge>
								<xsl:value-of select="$newline"/>
								<ref>
									<xsl:attribute name="id">
										<xsl:value-of
											select="substring-after(@target, 'people.html#')"/>
									</xsl:attribute>
									<xsl:call-template name="lookUpName">
										<xsl:with-param name="nameCode"
											select="normalize-space(substring-after(@target, 'people.html#'))"
										/>
									</xsl:call-template>
								</ref>
								<xsl:value-of select="$newline"/>
							</addressee>
							<xsl:value-of select="$newline"/>
							<xsl:if test="$addressee2id != ''">
								<addressee>
									<xsl:value-of select="$newline"/>
									<name>
										<xsl:attribute name="id">
											<xsl:value-of
												select="substring-after($addressee2id, 'people.html#')"
											/>
										</xsl:attribute>
										<xsl:value-of select="$addressee2"/>
									</name>
									<xsl:value-of select="$newline"/>
									<edge>
										<xsl:attribute name="letter">
											<xsl:value-of
												select="ancestor-or-self::tei:TEI/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='edition']"
											/>
										</xsl:attribute>
									</edge>
									<xsl:value-of select="$newline"/>
									<ref>
										<xsl:attribute name="id">
											<xsl:value-of
												select="substring-after(@target, 'people.html#')"/>
										</xsl:attribute>
										<xsl:call-template name="lookUpName">
											<xsl:with-param name="nameCode"
												select="normalize-space(substring-after(@target, 'people.html#'))"
											/>
										</xsl:call-template>
									</ref>
								</addressee>
								<xsl:value-of select="$newline"/>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="lookUpName">
		<xsl:param name="nameCode"/>
		<xsl:for-each
			select="substring-before(document('../people.xml')//*/tei:term[@xml:id=$nameCode], ':')">
			<xsl:value-of
				select="normalize-space(translate(translate(., '&#8211;', '&#45;'), '&#8216;&#8217;', ''))"
			/>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
