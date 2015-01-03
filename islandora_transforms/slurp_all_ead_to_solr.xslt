<?xml version="1.0" encoding="UTF-8"?>
<!-- Basic EAD -->
<xsl:stylesheet xmlns:ead="http://lcweb2.loc.gov/xmlcommon/dtds/ead2002/ead.dtd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foxml="info:fedora/fedora-system:def/foxml#" xmlns:ns2="http://www.w3.org/1999/xlink" xmlns="urn:isbn:1-931666-22-9" version="1.0">
  <xsl:template match="foxml:datastream[@ID='EAD']" name="index_EAD">
      <xsl:param name="content"/>
      <xsl:param name="prefix">ead_</xsl:param>
      <xsl:param name="suffix"></xsl:param>
      <xsl:apply-templates select="$content/ead">
        <xsl:with-param name="prefix" select="$prefix"/>
        <xsl:with-param name="suffix" select="$suffix"/>
      </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="ead">
      <xsl:param name="prefix">ead_</xsl:param>
      <xsl:param name="suffix"></xsl:param>
      <!-- Create fields for the set of selected elements, named according to the 'local-name' and containing the 'text' -->
      <xsl:for-each select="./*">
        <field>
          <xsl:attribute name="name">
            <xsl:value-of select="concat($prefix, local-name(), $suffix)"/>
          </xsl:attribute>
          <xsl:value-of select="text()"/>
        </field>
      </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
