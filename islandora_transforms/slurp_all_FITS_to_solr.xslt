<?xml version="1.0" encoding="UTF-8"?>
<!-- Basic MODS -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:fits="http://hul.harvard.edu/ois/xml/ns/fits/fits_output http://hul.harvard.edu/ois/xml/xsd/fits/fits_output.xsd"
     exclude-result-prefixes="fits">
  <xsl:include href="/usr/local/fedora/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms/library/xslt-date-template.xslt"/>

  <xsl:template match="foxml:datastream[@ID='TECHMD_FITS']/foxml:datastreamVersion[last()]" name="index_FITS">
    <xsl:param name="content"/>
    <xsl:param name="prefix"></xsl:param>
    <xsl:param name="suffix">ms</xsl:param>

    <xsl:apply-templates mode="slurping_FITS" select="$content//fits:fits[1]">
      <xsl:with-param name="prefix" select="$prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
      <xsl:with-param name="pid" select="../../@PID"/>
      <xsl:with-param name="datastream" select="../@ID"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Handle dates. -->
  <xsl:template match="fits:*[(@type='lastmodified') or (contains(translate(local-name(), 'D', 'd'), 'date'))][normalize-space(text())]" mode="slurping_FITS">
    <xsl:param name="prefix"/>
    <xsl:param name="suffix"/>
    <xsl:param name="pid">not provided</xsl:param>
    <xsl:param name="datastream">not provided</xsl:param>

    <xsl:variable name="textValue">
      <xsl:call-template name="get_ISO8601_date">
        <xsl:with-param name="date" select="normalize-space(text())"/>
        <xsl:with-param name="pid" select="$pid"/>
        <xsl:with-param name="datastream" select="$datastream"/>
      </xsl:call-template>
    </xsl:variable>

    <xsl:if test="not(normalize-space($textValue)='')">
    <!-- Use attributes in field name. -->
      <xsl:variable name="this_prefix">
        <xsl:value-of select="$prefix"/>
        <xsl:for-each select="@*">
          <xsl:value-of select="local-name()"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="."/>
          <xsl:text>_</xsl:text>
        </xsl:for-each>
      </xsl:variable>

      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($this_prefix, local-name(), '_dt')"/>
        </xsl:attribute>
        <xsl:value-of select="$textValue"/>
      </field>

      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($prefix, local-name(), '_mdt')"/>
        </xsl:attribute>
        <xsl:value-of select="$textValue"/>
      </field>
    </xsl:if>
  </xsl:template>

  <!-- Avoid using text alone. -->
  <xsl:template match="text()" mode="slurping_FITS"/>

  <!-- Build up the list prefix with the element context. -->
  <xsl:template match="*" mode="slurping_FITS">
    <xsl:param name="prefix"/>
    <xsl:param name="suffix"/>
    <xsl:param name="pid">not provided</xsl:param>
    <xsl:param name="datastream">not provided</xsl:param>

    <xsl:variable name="this_prefix">
      <xsl:value-of select="concat($prefix, local-name(), '_')"/>
      <xsl:if test="@type">
        <xsl:value-of select="@type"/>
        <xsl:text>_</xsl:text>
      </xsl:if>
    </xsl:variable>

    <xsl:variable name="textValue">
      <xsl:value-of select="normalize-space(text())"/>
    </xsl:variable>

    <xsl:if test="$textValue">
      <field>
        <xsl:attribute name="name">
          <xsl:value-of select="concat($this_prefix, $suffix)"/>
        </xsl:attribute>
        <xsl:value-of select="$textValue"/>
      </field>
    </xsl:if>

    <xsl:apply-templates mode="slurping_FITS">
      <xsl:with-param name="prefix" select="$this_prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
      <xsl:with-param name="pid" select="$pid"/>
      <xsl:with-param name="datastream" select="$datastream"/>
    </xsl:apply-templates>
  </xsl:template>
</xsl:stylesheet>
