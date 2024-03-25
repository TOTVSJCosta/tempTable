#include "totvs.ch"

user function TTable()
    local cAlias    := GetNextAlias()
    local aFields   := {}
    local oTTable   := FWTemporaryTable():New(cAlias)
    local oDlg      AS Object
    local oBrowse   AS Object

    aadd(aFields, {"tmpID",     'C', 10, 0})
    aadd(aFields, {"tmpDESCRI", 'C', 35, 0})
    aadd(aFields, {"tmpSTATUS", 'C', 1,  0})
    aadd(aFields, {"tmpDATA",   'D', 8,  0})
    aadd(aFields, {"tmpHORA",   'C', 8,  0})
    aadd(aFields, {"tmpRESULT", 'M', 10, 0})

    oTTable:SetFields(aFields)
    oTTable:AddIndex("01", {"tmpID"})
    oTTable:AddIndex("02", {"tmpDESCRI"})
    oTTable:Create()

    RecLock(cAlias, .t.)
        (cAlias)->tmpID     := "0000000001"
        (cAlias)->tmpDESCRI := "DESCRIÇÃO TESTE"
        (cAlias)->tmpSTATUS := "S"
        (cAlias)->tmpDATA   := Date()
        (cAlias)->tmpHORA   := time()
        (cAlias)->tmpRESULT := (cAlias)->(tmpID + CRLF + tmpDESCRI + CRLF + dtoc(tmpDATA) + CRLF + tmpHORA)
    (cAlias)->(msUnlock())

    DEFINE DIALOG oDlg TITLE "BrGetDDB Tabela temporária" FROM 180,180 TO 550,700 PIXEL 
 
    oBrowse := BrGetDDB():new(1,1,260,184,,,,oDlg,,,,,,,,,,,,.F.,cAlias,.T.,,.F.)
    oBrowse:bDelete := { || conOut( "bDelete" ) }
    oBrowse:addColumn( TCColumn():new( 'ID', { || (cAlias)->tmpID  },,,, 'LEFT',, .F., .F.,,,, .F. ) )
    oBrowse:addColumn( TCColumn():new( 'Descrição', { || (cAlias)->tmpDESCRI },,,, 'LEFT',, .F., .F.,,,, .F. ) )
    oBrowse:addColumn( TCColumn():new( 'Status', { || (cAlias)->tmpSTATUS },,,, 'LEFT',, .F., .F.,,,, .F. ) )
    oBrowse:addColumn( TCColumn():new( 'Data Execução', { || (cAlias)->tmpDATA },,,, 'LEFT',, .F., .F.,,,, .F. ) )
    oBrowse:addColumn( TCColumn():new( 'Hora Execução', { || (cAlias)->tmpHORA },,,, 'LEFT',, .F., .F.,,,, .F. ) )
    oBrowse:addColumn( TCColumn():new( 'Resultado', { || (cAlias)->tmpRESULT },,,, 'LEFT',, .F., .F.,,,, .F. ) )
 
    ACTIVATE DIALOG oDlg CENTERED

    oTTable:Delete()
return
