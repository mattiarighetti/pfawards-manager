ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    esame_id:integer
}
pf::permission
with_catch errmsg {
    db_dml esamereset ""
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile resettare il tempo dell'esame. Forse l'utente non ha ancora iniziato l'esame o in caso contrario, si prega di tornare indietro e riprovare.</b>"
    return
}
ad_returnredirect "esami-list"
ad_script_abort
