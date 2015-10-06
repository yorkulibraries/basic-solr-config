<?xml version="1.0" encoding="UTF-8"?>
<!-- Basic DFXML -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:dfxml="http://www.forensicswiki.org/wiki/Category:Digital_Forensics_XML"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#">

  <xsl:template match="foxml:datastream[@ID='TECHMD_DFXML']/foxml:datastreamVersion[last()]" name="index_dfxml">
    <xsl:param name="content"/>
    <xsl:param name="prefix"/>
    <xsl:param name="suffix">ms</xsl:param>
    <xsl:apply-templates mode="slurping_dfxml" select="$content//dfxml:dfxml[1]">
      <xsl:with-param name="prefix" select="$prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
      <xsl:with-param name="pid" select="../../@PID"/>
      <xsl:with-param name="datastream" select="../@ID"/>
    </xsl:apply-templates>
  </xsl:template>
  <!-- Avoid using text alone. -->
  <xsl:template match="text()" mode="slurping_dfxml"/>
  <!-- Build up the list prefix with the element context. -->
  <xsl:template match="*" mode="slurping_dfxml">
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
    <xsl:apply-templates mode="slurping_dfxml">
      <xsl:with-param name="prefix" select="$this_prefix"/>
      <xsl:with-param name="suffix" select="$suffix"/>
      <xsl:with-param name="pid" select="$pid"/>
      <xsl:with-param name="datastream" select="$datastream"/>
    </xsl:apply-templates>
  </xsl:template>
</xsl:stylesheet>
