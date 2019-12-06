<?xml version="1.0" encoding="UTF-8"?>
<!-- Glob text into one field for indexing. -->
<xsl:stylesheet version="1.0"
  xmlns:foxml="info:fedora/fedora-system:def/foxml#"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:exts="xalan://dk.defxws.fedoragsearch.server.GenericOperationsImpl"
  xmlns:islandora-exts="xalan://ca.upei.roblib.DataStreamForXSLT"
            exclude-result-prefixes="exts">
  <!-- Maintaining DSID mappings for backwards compatibility with wild implementations. -->
  <xsl:template match="foxml:datastream[@ID='OCR']/foxml:datastreamVersion[last()] " name="index_text">

    <xsl:param name="content"/>

    <field>
      <xsl:attribute name="name">
        <xsl:value-of select="concat(../@ID, '_t')"/>
      </xsl:attribute>
      <xsl:value-of select="$content"/>
  </field>

  </xsl:template>
</xsl:stylesheet>
