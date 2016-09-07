ad_page_contract {
    @author Mattia Righetti (mattia.righetti@mail.polimi.it)
} {
    risposta_id:integer
    domanda_id:integer
}
with_catch errmsg {
    db_dml query "DELETE FROM itfaw_risposte WHERE risposta_id = :risposte_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare la domanda. Si prega di tornare indietro e riprovare.</b>" 
    return
}
ad_returnredirect "risposte-list"
ad_script_abort
