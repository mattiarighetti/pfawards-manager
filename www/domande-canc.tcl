ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    domanda_id:integer
}
pf::permission
with_catch errmsg {
    db_dml domandecanc ""
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare la domanda. Si prega di tornare indietro e riprovare.</b>" 
    return
}
ad_returnredirect "domande-list"
ad_script_abort
