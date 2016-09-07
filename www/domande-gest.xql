<?xml version="1.0"?>
<queryset>
  <fullquery name="domandanum">
    <querytext>
      SELECT 'Numero #'||domanda_id FROM itfaw_domande WHERE domanda_id = :domanda_id
    </querytext>
  </fullquery>
  <fullquery name="categorialist">
    <querytext>
      SELECT descrizione, categoria_id FROM categoriaevento ORDER BY categoria_id
    </querytext>
  </fullquery>
  <fullquery name="selectdomanda">
    <querytext>
      SELECT corpo, categoria_id FROM itfaw_domande WHERE domanda_id = :domanda_id
    </querytext>
  </fullquery>
  <fullquery name="maxdomandaid">
    <querytext>
      SELECT COALESCE (MAX(domanda_id) + 1, 1) FROM itfaw_domande
    </querytext>
  </fullquery>
  <fullquery name="insert">
    <querytext>
      INSERT INTO itfaw_domande (domanda_id, corpo, categoria_id) VALUES (:domanda_id, :corpo, :categoria_id)
    </querytext>
  </fullquery>
  <fullquery name="update">
    <querytext>
      UPDATE itfaw_domande SET corpo = :corpo, categoria_id = :categoria_id WHERE domanda_id  = :domanda_id
    </querytext>
  </fullquery>
</queryset>