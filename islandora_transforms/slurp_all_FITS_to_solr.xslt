<?xml version="1.0" encoding="UTF-8"?>
<!-- Basic FITS -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:foxml="info:fedora/fedora-system:def/foxml#" xmlns:fits="http://hul.harvard.edu/ois/xml/ns/fits/fits_output" xmlns:mix="http://www.loc.gov/standards/mix/mix20/mix20.xsd" version="1.0">
  <xsl:template match="foxml:datastream[@ID='TECHMD_FITS']/foxml:datastreamVersion[last()]" name="index_fits">
    <xsl:param name="content"/>
    <xsl:param name="prefix"/>
    <xsl:param name="suffix">ms</xsl:param>
    <xsl:apply-templates mode="slurping_fits" select="$content//fits:fits[1]">
      <xsl:with-param name="prefix" select="$prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
      <xsl:with-param name="pid" select="../../@PID"/>
      <xsl:with-param name="datastream" select="../@ID"/>
    </xsl:apply-templates>
  </xsl:template>
  <!-- Avoid using text alone. -->
  <xsl:template match="text()" mode="slurping_fits"/>
  <!-- Build up the list prefix with the element context. -->
  <xsl:template match="*" mode="slurping_fits">
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
    <xsl:apply-templates mode="slurping_fits">
      <xsl:with-param name="prefix" select="$this_prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
      <xsl:with-param name="pid" select="$pid"/>
      <xsl:with-param name="datastream" select="$datastream"/>
    </xsl:apply-templates>
  </xsl:template>
</xsl:stylesheet>
