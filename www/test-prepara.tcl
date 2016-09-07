ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 19 February 2015
} {
    utente_id:integer
    categoria_id:integer
}
set esame_id [db_string query "select coalesce(max(esame_id) + 1) from itfaw_esami"]
if {$esame_id eq ""} {
    set esame_id 1
}
db_dml query "insert into itfaw_esami (esame_id, utente_id, categoria_id) values (:esame_id, :utente_id, :categoria_id)"
db_foreach query "select domanda_id from itfaw_domande where categoria_id = :categoria_id order by random() limit 5" {
    set rispusr_id [db_string query "select coalesce(max(rispusr_id) + 1) from itfaw_rispusr"]
    if {$rispusr_id eq ""} {
	set rispusr_id 1
    }
    db_dml query "insert into itfaw_rispusr (rispusr_id, domanda_id, esame_id) values (:rispusr_id, :domanda_id, :esame_id)"
}
ad_returnredirect [export_vars -base "test-sessione" {esame_id}]
ad_script_abort
