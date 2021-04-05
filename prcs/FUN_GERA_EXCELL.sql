=================================================================================
site de cor para excel http://www.mvps.org/dmcritchie/excel/colors.htm


v_cor_fundo := 0;
if :blk06.g2_dat_impressao is not null then
   v_cor_fundo := 4;       
else
   v_cor_fundo := 3;
end if;
if :blk06.g2_flg_oe in (4,5) then
    v_cor_fundo := 6;
end if;

COLCOUNT := 1;
ROWCOUNT := ROWCOUNT + 1;
PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT,  :blk06.G2_SEQ_PLANO  ,  NULL, 'Arial', '10', FALSE, FALSE, 0, null, null, 'VALUE', v_cor_fundo);
COLCOUNT := COLCOUNT + 1;
PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT,  :blk06.G2_COD_SEQUENCIA ,  NULL, 'Arial', '10', FALSE, FALSE, 0, null, null, 'VALUE', v_cor_fundo);

=================================================================================




PROCEDURE FUN_GERA_EXCELL (P_EMPRESA  NUMBER, 
                           P_FILIAL   NUMBER,
                           P_DATA_INI DATE,
                           P_DATA_FIM DATE) IS
declare
   
-- DECLARA VARIÁVEIS PARA OS OBJETOS.
APPLICATION  OLE2.OBJ_TYPE;
WORKBOOKS    OLE2.OBJ_TYPE;
WORKBOOK     OLE2.OBJ_TYPE;
WORKSHEET    OLE2.OBJ_TYPE;
CELL         OLE2.OBJ_TYPE;
FONT         OLE2.OBJ_TYPE;
V_BLOCO_CONF NUMBER;

-- DECLARA RECIPIENTES PARA LISTAS DE ARGUMENTOS OLE 
ARGS OLE2.LIST_TYPE; 
V_ALERT          NUMBER;
ROWCOUNT         NUMBER := 1; -- contador de linhas 
COLCOUNT         NUMBER := 1; -- contador de colunas
ROWCOUNT_SUBLIN  NUMBER := 1; -- contador de sublinhas  



-- DECLARA SUBTIPOS DE FORMATAÇÃO 
SUBTYPE xlHAlign IS binary_integer; 
CENTER                CONSTANT xlHAlign := - 4108; 
CENTERACROSSSELECTION CONSTANT xlHAlign := 7; 
DISTRIBUTED           CONSTANT xlHAlign := - 4117; 
FILL                  CONSTANT xlHAlign := 5; 
GENERAL               CONSTANT xlHAlign := 1; 
JUSTIFY               CONSTANT xlHAlign := - 4130; 
LEFT                  CONSTANT xlHAlign := - 4131; 
RIGHT                 CONSTANT xlHAlign := - 4152; 
v_tot_produ           NUMBER :=0;
v_tot_rejei           NUMBER :=0; 
v_calc_perc           NUMBER :=0;
V_VLR_METAS           NUMBER :=0;

CURSOR c_metas (vc_DIVISAO NUMBER, VC_SECAO NUMBER, VC_ANO NUMBER, VC_MES NUMBER) IS
   SELECT TRUNC(SUM(nvl(NRO_QTDE_PARES,0)))
     FROM epi_meta_qualidade
    WHERE COD_EMPRESA = cod_empresa
      AND COD_FILIAL  = cod_filial
      AND COD_DIVISAO = vc_DIVISAO
      AND COD_SECAO   = VC_SECAO
      AND NRO_ANO     = VC_ANO
      AND NRO_MES     = VC_MES;
      
begin

   -- cursor de sistema ocupado
   SET_APPLICATION_PROPERTY(CURSOR_STYLE, 'BUSY');
   
   -- DECLARA RECIPIENTES PARA OBJETO DE APLICAÇÃO 
   APPLICATION := OLE2.CREATE_OBJ( 'EXCEL.APPLICATION' ) ; 
      
   -- CRIA UMA COLEÇÃO DE WORKBOOKS E ADICIONA UM NOVO WORKBOOK 
   WORKBOOKS := OLE2.GET_OBJ_PROPERTY( APPLICATION, 'WORKBOOKS' ) ; 
   WORKBOOK  := OLE2.GET_OBJ_PROPERTY( WORKBOOKS, 'ADD' ) ; 
      
   -- ABRE A WORKSHEET PLAN1 NO WORKBOOK 
   ARGS := OLE2.CREATE_ARGLIST; 
   OLE2.ADD_ARG( ARGS, 'PLAN1' ) ; 
   WORKSHEET := OLE2.GET_OBJ_PROPERTY( WORKBOOK, 'WORKSHEETS', ARGS ) ; 
   OLE2.DESTROY_ARGLIST( ARGS ) ; 
      
   -- CABECALHO
   PREENCHE_CEL( WORKSHEET, CELL, ARGS, 02, 1, 'RELATORIO SEMANAL DE CONTROLE DA QUALIDADE', NULL, 'Arial', '10', FALSE, FALSE, 0);
    
   --Parametros de Relatório
   PREENCHE_CEL( WORKSHEET, CELL, ARGS, 04, 1, :BLK_LABEL.EMP_FIL, NULL, 'Arial', '10', FALSE, FALSE, 0);
   PREENCHE_CEL( WORKSHEET, CELL, ARGS, 04, 2, :BLK01.COD_EMPRESA||' - '||:BLK01.COD_FILIAL||' - '||:BLK01.DES_FILIAL, NULL, 'Arial', '10', FALSE, FALSE, 0);
   PREENCHE_CEL( WORKSHEET, CELL, ARGS, 05, 1, :BLK_LABEL.DATA_INICIAL, NULL, 'Arial', '10', FALSE, FALSE, 0);
   PREENCHE_CEL( WORKSHEET, CELL, ARGS, 05, 2, TO_CHAR(:BLK01.DAT_INICIO,'DD/MM/YYYY'), NULL, 'Arial', '10', FALSE, FALSE, 0);
   PREENCHE_CEL( WORKSHEET, CELL, ARGS, 06, 1, :BLK_LABEL.DATA_FINAL, NULL, 'Arial', '10', FALSE, FALSE, 0);
   PREENCHE_CEL( WORKSHEET, CELL, ARGS, 06, 2, TO_CHAR(:BLK01.DAT_FIM,'DD/MM/YYYY'), NULL, 'Arial', '10', FALSE, FALSE, 0);   
   FOR CABECALHO IN (select Ano, Mes, cod_empresa, cod_filial, cod_divisao,cod_secao,
                            pck_epis.fun_divisao(cod_empresa, cod_filial, cod_divisao)des_divisao, 
                            pck_epis.fun_secoes(cod_empresa, cod_filial, cod_divisao,cod_secao)des_secao, 
                            sum(decode(semana,1,qtd_par,0)) semana_produ1,
                            sum(decode(semana,2,qtd_par,0)) semana_produ2,
                            sum(decode(semana,3,qtd_par,0)) semana_produ3,
                            sum(decode(semana,4,qtd_par,0)) semana_produ4,
                            sum(decode(semana,5,qtd_par,0)) semana_produ5,
                            sum(decode(semana,1,num_qtde_pares,0)) semana_quali1,
                            sum(decode(semana,2,num_qtde_pares,0)) semana_quali2,
                            sum(decode(semana,3,num_qtde_pares,0)) semana_quali3,
                            sum(decode(semana,4,num_qtde_pares,0)) semana_quali4,
                            sum(decode(semana,5,num_qtde_pares,0)) semana_quali5
                       from (
                     select to_char(a.dat_controle, 'MM') Mes, to_char(a.dat_controle, 'YYYY') ANO, to_char(a.dat_controle, 'w')semana,
                            a.cod_empresa, a.cod_filial, a.cod_divisao, a.cod_secao, 
                            0 qtd_par, a.num_qtde_pares
                       from epi_controle_qualidade a
                      WHERE a.cod_empresa = P_EMPRESA
                        and a.cod_filial  = P_FILIAL
                        and trunc(a.dat_controle) >= P_DATA_INI
                        and trunc(a.dat_controle) <= P_DATA_FIM
                      UNION ALL
                     SELECT to_char(a.dat_baixa, 'MM') Mes,to_char(a.dat_baixa, 'YYYY') ANO, to_char(a.dat_baixa, 'W')Semana,
                            a.cod_empresa, a.cod_filial, a.cod_divisao, a.cod_secao, 
                            b.qtd_par, 0 num_qtde_pares
                       FROM epi_pla_baixa_up_secao a, epi_pla_ficha_producao b
                      WHERE A.COD_EMPRESA       = P_EMPRESA
                        AND A.COD_FILIAL        = P_FILIAL
                        AND trunc(a.dat_baixa) >= P_DATA_INI
                        AND trunc(a.dat_baixa) <= P_DATA_FIM
                        and b.seq_ficha   = a.seq_ficha
                     )
                     group by ano, Mes,cod_empresa, cod_filial, cod_divisao, cod_secao
                     ORDER BY des_divisao,des_secao)
   LOOP
      v_tot_produ := CABECALHO.semana_produ1+CABECALHO.semana_produ2+CABECALHO.semana_produ3+CABECALHO.semana_produ4+CABECALHO.semana_produ5;
      v_tot_rejei := CABECALHO.semana_quali1+CABECALHO.semana_quali2+CABECALHO.semana_quali3+CABECALHO.semana_quali4+CABECALHO.semana_quali5; 
      --Titulo
      ROWCOUNT := 08;
      COLCOUNT := 01;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, 'Setor:'||cabecalho.des_divisao||'/'||cabecalho.des_secao, NULL, 'Arial', '10', FALSE, FALSE, 0);
      ROWCOUNT := ROWCOUNT + 1;
      COLCOUNT := 5;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, 'Resultado Semanal', NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 5;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, 'Acumulado Mensal', NULL, 'Arial', '10', FALSE, FALSE, 0);
      ROWCOUNT := ROWCOUNT + 1;
      COLCOUNT := 2;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, '1a Semana', NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, '2a Semana', NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, '3a Semana', NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, '4a Semana', NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, '5a Semana', NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 3;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, 'Mes Atual', NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, 'Mes Anterior', NULL, 'Arial', '10', FALSE, FALSE, 0);
      ROWCOUNT := ROWCOUNT + 1;
      COLCOUNT := 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, 'Quantidade Revisada (Pares)', NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, cabecalho.semana_produ1, NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, cabecalho.semana_produ2, NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, cabecalho.semana_produ3, NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, cabecalho.semana_produ4, NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, cabecalho.semana_produ5, NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 3;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, v_tot_produ, NULL, 'Arial', '10', FALSE, FALSE, 0);
      ROWCOUNT := ROWCOUNT + 1;
      COLCOUNT := 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, 'Quantidade Revisada (Pares)', NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, cabecalho.semana_quali1, NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, cabecalho.semana_quali2, NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, cabecalho.semana_quali3, NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, cabecalho.semana_quali4, NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, cabecalho.semana_quali5, NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 3;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, v_tot_rejei, NULL, 'Arial', '10', FALSE, FALSE, 0);

      ROWCOUNT := ROWCOUNT + 1;
      COLCOUNT := 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, 'Percentual de Rejeito (%)', NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      IF cabecalho.semana_quali1 <> 0 AND cabecalho.semana_produ1 <> 0 THEN
         v_calc_perc := cabecalho.semana_quali1/cabecalho.semana_produ1;
      ELSE
         v_calc_perc := 0;
      END IF;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, v_calc_perc, NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      IF cabecalho.semana_quali2 <> 0 AND cabecalho.semana_produ2 <> 0 THEN
         v_calc_perc := cabecalho.semana_quali2/cabecalho.semana_produ2;
      ELSE
         v_calc_perc := 0;
      END IF;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, v_calc_perc, NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      IF cabecalho.semana_quali3 <> 0 AND cabecalho.semana_produ3 <> 0 THEN
         v_calc_perc := cabecalho.semana_quali3/cabecalho.semana_produ3;
      ELSE
         v_calc_perc := 0;
      END IF;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, v_calc_perc, NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      IF cabecalho.semana_quali4 <> 0 AND cabecalho.semana_produ4 <> 0 THEN
         v_calc_perc := cabecalho.semana_quali4/cabecalho.semana_produ4;
      ELSE
         v_calc_perc := 0;
      END IF;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, v_calc_perc, NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      IF cabecalho.semana_quali5 <> 0 AND cabecalho.semana_produ5 <> 0 THEN
         v_calc_perc := cabecalho.semana_quali5/cabecalho.semana_produ5;
      ELSE
         v_calc_perc := 0;
      END IF;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, v_calc_perc, NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 3;
      IF v_tot_rejei <> 0 AND v_tot_produ <> 0 THEN
         v_calc_perc := v_tot_rejei/v_tot_produ;
      ELSE
         v_calc_perc := 0;
      END IF;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, v_calc_perc, NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := 1;
      ROWCOUNT := ROWCOUNT + 2;

      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, 'META %', NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 1;
      OPEN c_metas(CABECALHO.cod_divisao,CABECALHO.cod_secao, CABECALHO.ano, CABECALHO.mes);
      FETCH c_metas INTO V_VLR_METAS;
      IF c_metas@NOTFOUND THEN
         V_VLR_METAS := 0;
      END IF;
      CLOSE c_metas;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, V_VLR_METAS, NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 5;
      IF v_calc_perc > V_VLR_METAS THEN
         PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, 'ATENCAO', NULL, 'Arial', '10', FALSE, FALSE, 0);
      ELSE
         PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, 'BOM', NULL, 'Arial', '10', FALSE, FALSE, 0);
      END IF;
      ROWCOUNT := ROWCOUNT + 2;
      COLCOUNT := 1;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, '* MAIORES DEFEITOS', NULL, 'Arial', '10', FALSE, FALSE, 0);
      COLCOUNT := COLCOUNT + 5;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, '* MAIORES DEFEITOS', NULL, 'Arial', '10', FALSE, FALSE, 0);
      ROWCOUNT := ROWCOUNT + 1;
      ROWCOUNT_SUBLIN := ROWCOUNT;
      COLCOUNT := 1;
      FOR defeito IN (SELECT des_defeito, qtde_defeitos
                        FROM (
                      SELECT b.des_defeito, sum(num_qtde_pares) qtde_defeitos
                        FROM epi_controle_qualidade a, epi_pla_defeito b
                       WHERE a.cod_empresa = 49
                         AND a.cod_filial = 2
                         AND a.cod_divisao = 163
                         AND a.cod_secao = 1
                         and a.dat_controle >= p_dtini
                         and a.dat_controle <= p_dtfim
                         AND b.seq_defeito = a.seq_defeito
                       GROUP BY b.des_defeito
                       ORDER BY qtde_defeitos DESC)
                       WHERE ROWNUM < 6)
      LOOP
         PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, defeito.des_defeito, NULL, 'Arial', '10', FALSE, FALSE, 0);   
         COLCOUNT := COLCOUNT + 1;
         PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, defeito.qtde_defeitos, NULL, 'Arial', '10', FALSE, FALSE, 0);   
         COLCOUNT := COLCOUNT + 1;
         PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, 'PRS', NULL, 'Arial', '10', FALSE, FALSE, 0);   
         COLCOUNT := COLCOUNT + 1;
         
         PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, defeito.des_defeito, NULL, 'Arial', '10', FALSE, FALSE, 0);   
         COLCOUNT := COLCOUNT + 1;
      END LOOP;
      PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, 'Bloco conferencia', NULL, 'Arial', '10', FALSE, FALSE, 0);                  
     COLCOUNT := 1;
     ROWCOUNT := ROWCOUNT + 1;
    
  go_block('BLK04');
  first_record;
  while not :BLK04.SEQ_ORDEM_EMBARQUE is null loop
     OPEN  C_PLANO_PEDIDO(:BLK05.COD_EMPRESA,:BLK05.COD_FILIAL,:BLK04.SEQ_PEDIDO);
     FETCH C_PLANO_PEDIDO INTO V_BLOCO_CONF;
     CLOSE C_PLANO_PEDIDO;
        
    PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, :BLK04.SEQ_ORDEM_EMBARQUE, NULL, 'Arial', '10', FALSE, FALSE, 0);
    COLCOUNT := COLCOUNT + 1;
     PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, TO_CHAR(:BLK04.DAT_EMISSAO,'DD/MM/YYYY'), NULL, 'Arial', '10', FALSE, FALSE, 0);
     COLCOUNT := COLCOUNT + 1;
     PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, :BLK04.SEQ_PEDIDO, NULL, 'Arial', '10', FALSE, FALSE, 0);
     COLCOUNT := COLCOUNT + 1;
     PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, REPLACE(TO_CHAR(:BLK04.QTD_EMBARCAR),'.',','), NULL, 'Arial', '10', FALSE, FALSE, 0);
    COLCOUNT := COLCOUNT + 1;
     PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, REPLACE(TO_CHAR(:BLK04.QTD_EMBARCADO),'.',','), NULL, 'Arial', '10', FALSE, FALSE, 0);
     COLCOUNT := COLCOUNT + 1;
     PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, :BLK04.QTD_RESTANTE, NULL, 'Arial', '10', FALSE, FALSE, 0);
     COLCOUNT := COLCOUNT + 1;
     PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, :BLK04.SITUACAO, NULL, 'Arial', '10', FALSE, FALSE, 0);    
     COLCOUNT := COLCOUNT + 1;
     PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, :BLK04.DES_USER_IMPRESSAO, NULL, 'Arial', '10', FALSE, FALSE, 0);        
     COLCOUNT := COLCOUNT + 1;
     PREENCHE_CEL( WORKSHEET, CELL, ARGS, ROWCOUNT, COLCOUNT, V_BLOCO_CONF, NULL, 'Arial', '10', FALSE, FALSE, 0);         
    COLCOUNT := 1;
    ROWCOUNT := ROWCOUNT + 1;
    next_record;
   END LOOP;
   first_record;

   -- PERMITE AO USER VER A APLICAÇÃO DO EXCEL PARA VER O RESULTADO. 
   OLE2.SET_PROPERTY( APPLICATION, 'VISIBLE', TRUE ) ; 
         
   -- LIBERA RECIPIENTES DA MEMÓRIA
   OLE2.RELEASE_OBJ( WORKSHEET );
   OLE2.RELEASE_OBJ( WORKBOOK );
   OLE2.RELEASE_OBJ( WORKBOOKS );
   OLE2.RELEASE_OBJ( APPLICATION );
   
   -- EXIBE UMA MENSAGEM CONFIRMANDO                
   SET_APPLICATION_PROPERTY( CURSOR_STYLE, 'DEFAULT' ) ; -- cursor volta ao normal. 
   

EXCEPTION
  WHEN OTHERS THEN 
       SET_APPLICATION_PROPERTY( CURSOR_STYLE, 'DEFAULT' ) ; 
       CLEAR_MESSAGE; 
       OLE2.RELEASE_OBJ( WORKSHEET ) ; 
       OLE2.RELEASE_OBJ( WORKBOOK ) ; 
       OLE2.RELEASE_OBJ( WORKBOOKS ) ; 
       OLE2.Release_Obj( application ) ; 
       message( 'Error'||sqlerrm );
       RAISE FORM_TRIGGER_FAILURE;   
END;

   
