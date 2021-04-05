CREATE OR REPLACE FUNCTION cpd_fextenso_monetario ( valor NUMBER ) RETURN VARCHAR2 IS
   valor_string  VARCHAR2( 256 );
   valor_conv    VARCHAR2(25);
   ind           NUMBER;
   tres_digitos  VARCHAR2(3);
   texto_string  VARCHAR2(256);

BEGIN
   valor_conv := to_char( trunc((abs(valor) * 100),0) , '0999999999999999999' );
   valor_conv := substr( valor_conv , 1 , 18 ) || '0' || substr( valor_conv , 19, 2 );

   IF UPPER(USER) = 'DBPGY' THEN
      IF to_number( valor_conv ) = 0 THEN
         RETURN( 'CERO ' );
      END IF;
      FOR ind IN 1..7
      LOOP
         tres_digitos := substr( valor_conv , (((ind-1)*3)+1) , 3 );
         texto_string := '' ;
         IF ind <> 7 THEN 
           -- Extenso para Centena
           IF substr(tres_digitos,1,1) = '2' THEN
              texto_string := texto_string || 'DOSCIENTOS ' ;
           ELSIF substr(tres_digitos,1,1) = '3' THEN
              texto_string := texto_string || 'TRESCIENTOS ' ;
           ELSIF substr(tres_digitos,1,1) = '4' THEN
              texto_string := texto_string || 'CUATROCIENTOS ' ;
           ELSIF substr(tres_digitos,1,1) = '5' THEN
              texto_string := texto_string || 'QUINIENTOS ' ;
           ELSIF substr(tres_digitos,1,1) = '6' THEN
              texto_string := texto_string || 'SEISCIENTOS ' ;
           ELSIF substr(tres_digitos,1,1) = '7' THEN
              texto_string := texto_string || 'SETECIENTOS ' ;
           ELSIF substr(tres_digitos,1,1) = '8' THEN
              texto_string := texto_string || 'OCHOCIENTOS ' ;
           ELSIF substr(tres_digitos,1,1) = '9' THEN
              texto_string := texto_string || 'NOVECIENTOS ' ;
           END IF;
           IF substr(tres_digitos,1,1) = '1' THEN
              IF substr(tres_digitos,2,2) = '00' THEN
                 texto_string := texto_string || 'CIEN ' ;
              ELSE
                 texto_string := texto_string || 'CIENTO ' ;
              END IF;
           END IF;
         -- Extenso para Dezena
           IF substr(tres_digitos,2,1) <> '0' AND texto_string IS NOT NULL THEN
              texto_string := texto_string || ' ';
           END IF;
           IF substr(tres_digitos,2,1) = '2' THEN
              texto_string := texto_string ||'VEINTE ';
           ELSIF substr(tres_digitos,2,1) = '3' THEN
              texto_string := texto_string ||'TREINTA ';
           ELSIF substr(tres_digitos,2,1) = '4' THEN
              texto_string := texto_string ||'CUARENTA ';
           ELSIF substr(tres_digitos,2,1) = '5' THEN
              texto_string := texto_string ||'CINCUENTA ';
           ELSIF substr(tres_digitos,2,1) = '6' THEN
              texto_string := texto_string ||'SESENTA ';
           ELSIF substr(tres_digitos,2,1) = '7' THEN
              texto_string := texto_string ||'SETENTA ';
           ELSIF substr(tres_digitos,2,1) = '8' THEN
              texto_string := texto_string ||'OCHENTA ';
           ELSIF substr(tres_digitos,2,1) = '9' THEN
              texto_string := texto_string ||'NOVENTA ';
           END IF;
           IF substr(tres_digitos,2,1) = '1' THEN
              IF substr(tres_digitos,3,1) <> '0' THEN
                 IF substr(tres_digitos,3,1) = '1' THEN
                    texto_string := texto_string ||'ONCE ';
                 ELSIF substr(tres_digitos,3,1) = '2' THEN
                    texto_string := texto_string ||'DOCE ';
                 ELSIF substr(tres_digitos,3,1) = '3' THEN
                    texto_string := texto_string ||'TRECE ';
                 ELSIF substr(tres_digitos,3,1) = '4' THEN
                    texto_string := texto_string ||'CATORCE ';
                 ELSIF substr(tres_digitos,3,1) = '5' THEN
                    texto_string := texto_string ||'QUINCE ';
                 ELSIF substr(tres_digitos,3,1) = '6' THEN
                    texto_string := texto_string ||'DIECISEIS ';
                 ELSIF substr(tres_digitos,3,1) = '7' THEN
                    texto_string := texto_string ||'DIECISIETE ';
                 ELSIF substr(tres_digitos,3,1) = '8' THEN
                    texto_string := texto_string ||'DIECIOCHO ';
                 ELSIF substr(tres_digitos,3,1) = '9' THEN
                    texto_string := texto_string ||'DIECINUEVE ';
                 END IF;
              ELSE
                 texto_string := texto_string ||'DIEZ ' ;
              END IF;
           ELSE
              -- Extenso para Unidade
              IF substr(tres_digitos,3,1) <> '0' AND texto_string IS NOT NULL THEN
                 texto_string := texto_string || 'Y ';
              END IF;
              IF substr(tres_digitos,3,1) = '1' THEN
                 texto_string := texto_string ||'UN ';
              ELSIF substr(tres_digitos,3,1) = '2' THEN
                 texto_string := texto_string ||'DOS ';
              ELSIF substr(tres_digitos,3,1) = '3' THEN
                 texto_string := texto_string ||'TRES ';
              ELSIF substr(tres_digitos,3,1) = '4' THEN
                 texto_string := texto_string ||'CUATRO ';
              ELSIF substr(tres_digitos,3,1) = '5' THEN
                 texto_string := texto_string ||'CINCO ';
              ELSIF substr(tres_digitos,3,1) = '6' THEN
                 texto_string := texto_string ||'SEIS ';
              ELSIF substr(tres_digitos,3,1) = '7' THEN
                 texto_string := texto_string ||'SIETE ';
              ELSIF substr(tres_digitos,3,1) = '8' THEN
                 texto_string := texto_string ||'OCHO ';
              ELSIF substr(tres_digitos,3,1) = '9' THEN
                 texto_string := texto_string ||'NUEVE ';
              END IF;
           END IF;
         ELSE
           IF lpad(to_char(to_number(tres_digitos)),2,'0') <> '00' THEN
              texto_string := lpad(to_char(to_number(tres_digitos)),2,'0')||'/100';
           END IF;
         END IF;
         IF to_number( tres_digitos ) > 0 THEN
            IF to_number( tres_digitos ) = 1 THEN
               IF ind = 1 THEN
                  texto_string := texto_string || 'QUATRILLON ' ;
               ELSIF ind = 2 THEN
                  texto_string := texto_string || 'TRILLHON ' ;
               ELSIF ind = 3 THEN
                  texto_string := texto_string || 'BILLHON ' ;
               ELSIF ind = 4 THEN
                  texto_string := texto_string || 'MILLON ' ;
               ELSIF ind = 5 THEN
                  texto_string := texto_string || 'MIL ' ;
               END IF;
            ELSE
               IF ind = 1 THEN
                  texto_string := texto_string || 'QUATRILLONES ' ;
               ELSIF ind = 2 THEN
                  texto_string := texto_string || 'TRILLHONES ' ;
               ELSIF ind = 3 THEN
                  texto_string := texto_string || 'BILLHONES ' ;
               ELSIF ind = 4 THEN
                  texto_string := texto_string || 'MILLONES ' ;
               ELSIF ind = 5 THEN
                  texto_string := texto_string || 'MIL ' ;
               END IF;
            END IF;
         END IF;
         valor_string := valor_string || texto_string;
         -- Escrita da Moeda Corrente
         IF ind = 5 THEN
             IF to_number( substr( valor_conv , 16 , 3 )) > 0 AND valor_string IS NOT NULL THEN
                valor_string := rtrim(valor_string) || ' ';
             END IF;
         ELSE
            IF ind < 5 AND valor_string IS NOT NULL THEN
               valor_string := rtrim(valor_string) || ' ';
            END IF;
         END IF;
         IF ind = 6 THEN
/*            IF to_number( substr( valor_conv , 1 , 18 ) ) > 1 THEN
               valor_string := valor_string || 'PESOS ';
            ELSIF to_number( substr( valor_conv , 1 , 18 ) ) = 1 THEN
               valor_string := valor_string || 'PESO ';
            END IF;*/
            IF to_number( substr( valor_conv , 20 , 2 ) ) > 0 AND length(valor_string) > 0  THEN
               valor_string := valor_string || 'CON ';
            END IF;
         END IF;
         -- Escrita para Centavos
        /* IF ind = 7 THEN
            IF to_number( substr( valor_conv , 20 , 2 ) ) > 1 THEN
               valor_string := valor_string  || 'CENTAVOS ';
            ELSIF to_number( substr( valor_conv , 20 , 2 ) ) = 1 THEN
               valor_string := valor_string  || 'CENTAVO ';
            END IF;
         END IF;*/
      END LOOP;
----- ATE AQUI
   ELSE
      IF to_number( valor_conv ) = 0 THEN
         RETURN( 'Zero ' );
      END IF;
      FOR ind IN 1..7
      LOOP
         tres_digitos := substr( valor_conv , (((ind-1)*3)+1) , 3 );
         texto_string := '' ;
         -- Extenso para Centena
         IF substr(tres_digitos,1,1) = '2' THEN
            texto_string := texto_string || 'Duzentos ' ;
         ELSIF substr(tres_digitos,1,1) = '3' THEN
            texto_string := texto_string || 'Trezentos ' ;
         ELSIF substr(tres_digitos,1,1) = '4' THEN
            texto_string := texto_string || 'Quatrocentos ' ;
         ELSIF substr(tres_digitos,1,1) = '5' THEN
            texto_string := texto_string || 'Quinhentos ' ;
         ELSIF substr(tres_digitos,1,1) = '6' THEN
            texto_string := texto_string || 'Seiscentos ' ;
         ELSIF substr(tres_digitos,1,1) = '7' THEN
            texto_string := texto_string || 'Setecentos ' ;
         ELSIF substr(tres_digitos,1,1) = '8' THEN
            texto_string := texto_string || 'Oitocentos ' ;
         ELSIF substr(tres_digitos,1,1) = '9' THEN
            texto_string := texto_string || 'Novecentos ' ;
         END IF;
         IF substr(tres_digitos,1,1) = '1' THEN
            IF substr(tres_digitos,2,2) = '00' THEN
               texto_string := texto_string || 'Cem ' ;
            ELSE
               texto_string := texto_string || 'Cento ' ;
            END IF;
         END IF;
       -- Extenso para Dezena
         IF substr(tres_digitos,2,1) <> '0' AND texto_string IS NOT NULL THEN
            texto_string := texto_string || 'e ';
         END IF;
         IF substr(tres_digitos,2,1) = '2' THEN
            texto_string := texto_string ||'Vinte ';
         ELSIF substr(tres_digitos,2,1) = '3' THEN
            texto_string := texto_string ||'Trinta ';
         ELSIF substr(tres_digitos,2,1) = '4' THEN
            texto_string := texto_string ||'Quarenta ';
         ELSIF substr(tres_digitos,2,1) = '5' THEN
            texto_string := texto_string ||'Cinquenta ';
         ELSIF substr(tres_digitos,2,1) = '6' THEN
            texto_string := texto_string ||'Sessenta ';
         ELSIF substr(tres_digitos,2,1) = '7' THEN
            texto_string := texto_string ||'Setenta ';
         ELSIF substr(tres_digitos,2,1) = '8' THEN
            texto_string := texto_string ||'Oitenta ';
         ELSIF substr(tres_digitos,2,1) = '9' THEN
            texto_string := texto_string ||'Noventa ';
         END IF;
         IF substr(tres_digitos,2,1) = '1' THEN
            IF substr(tres_digitos,3,1) <> '0' THEN
               IF substr(tres_digitos,3,1) = '1' THEN
                  texto_string := texto_string ||'Onze ';
               ELSIF substr(tres_digitos,3,1) = '2' THEN
                  texto_string := texto_string ||'Doze ';
               ELSIF substr(tres_digitos,3,1) = '3' THEN
                  texto_string := texto_string ||'Treze ';
               ELSIF substr(tres_digitos,3,1) = '4' THEN
                  texto_string := texto_string ||'Catorze ';
               ELSIF substr(tres_digitos,3,1) = '5' THEN
                  texto_string := texto_string ||'Quinze ';
               ELSIF substr(tres_digitos,3,1) = '6' THEN
                  texto_string := texto_string ||'Dezesseis ';
               ELSIF substr(tres_digitos,3,1) = '7' THEN
                  texto_string := texto_string ||'Dezessete ';
               ELSIF substr(tres_digitos,3,1) = '8' THEN
                  texto_string := texto_string ||'Dezoito ';
               ELSIF substr(tres_digitos,3,1) = '9' THEN
                  texto_string := texto_string ||'Dezenove ';
               END IF;
            ELSE
               texto_string := texto_string ||'Dez ' ;
            END IF;
         ELSE
         -- Extenso para Unidade
            IF substr(tres_digitos,3,1) <> '0' AND texto_string IS NOT NULL THEN
               texto_string := texto_string || 'e ';
            END IF;
            IF substr(tres_digitos,3,1) = '1' THEN
               texto_string := texto_string ||'Um ';
            ELSIF substr(tres_digitos,3,1) = '2' THEN
               texto_string := texto_string ||'Dois ';
            ELSIF substr(tres_digitos,3,1) = '3' THEN
               texto_string := texto_string ||'Tres ';
            ELSIF substr(tres_digitos,3,1) = '4' THEN
               texto_string := texto_string ||'Quatro ';
            ELSIF substr(tres_digitos,3,1) = '5' THEN
               texto_string := texto_string ||'Cinco ';
            ELSIF substr(tres_digitos,3,1) = '6' THEN
               texto_string := texto_string ||'Seis ';
            ELSIF substr(tres_digitos,3,1) = '7' THEN
               texto_string := texto_string ||'Sete ';
            ELSIF substr(tres_digitos,3,1) = '8' THEN
               texto_string := texto_string ||'Oito ';
            ELSIF substr(tres_digitos,3,1) = '9' THEN
               texto_string := texto_string ||'Nove ';
            END IF;
         END IF;
         IF to_number( tres_digitos ) > 0 THEN
            IF to_number( tres_digitos ) = 1 THEN
               IF ind = 1 THEN
                  texto_string := texto_string || 'Quatrilhao ' ;
               ELSIF ind = 2 THEN
                  texto_string := texto_string || 'Trilhao ' ;
               ELSIF ind = 3 THEN
                  texto_string := texto_string || 'Bilhao ' ;
               ELSIF ind = 4 THEN
                  texto_string := texto_string || 'Milhao ' ;
               ELSIF ind = 5 THEN
                  texto_string := texto_string || 'Mil ' ;
               END IF;
            ELSE
               IF ind = 1 THEN
                  texto_string := texto_string || 'Quatrilhoes ' ;
               ELSIF ind = 2 THEN
                  texto_string := texto_string || 'Trilhoes ' ;
               ELSIF ind = 3 THEN
                  texto_string := texto_string || 'Bilhoes ' ;
               ELSIF ind = 4 THEN
                  texto_string := texto_string || 'Milhoes ' ;
               ELSIF ind = 5 THEN
                  texto_string := texto_string || 'Mil ' ;
               END IF;
            END IF;
         END IF;
         valor_string := valor_string || texto_string;
         -- Escrita da Moeda Corrente
         IF ind = 5 THEN
             IF to_number( substr( valor_conv , 16 , 3 )) > 0 AND valor_string IS NOT NULL THEN
                valor_string := rtrim(valor_string) || ', ';
             END IF;
         ELSE
            IF ind < 5 AND valor_string IS NOT NULL THEN
               valor_string := rtrim(valor_string) || ', ';
            END IF;
         END IF;
         IF ind = 6 THEN
            IF to_number( substr( valor_conv , 1 , 18 ) ) > 1 THEN
               valor_string := valor_string || 'Reais ';
            ELSIF to_number( substr( valor_conv , 1 , 18 ) ) = 1 THEN
               valor_string := valor_string || 'Real ';
            END IF;

            IF to_number( substr( valor_conv , 20 , 2 ) ) > 0 AND length(valor_string) > 0  THEN
               valor_string := valor_string || 'e ';
            END IF;
         END IF;
         -- Escrita para Centavos
         IF ind = 7 THEN
            IF to_number( substr( valor_conv , 20 , 2 ) ) > 1 THEN
               valor_string := valor_string  || 'Centavos ';
            ELSIF to_number( substr( valor_conv , 20 , 2 ) ) = 1 THEN
               valor_string := valor_string  || 'Centavo ';
            END IF;
         END IF;
      END LOOP;
   END IF;

   RETURN( rtrim(valor_string) );

EXCEPTION
   WHEN OTHERS THEN RETURN( '*** VALOR INVALIDO ***' );

END cpd_fextenso_monetario;
/


CREATE OR REPLACE FUNCTION cpd_fextenso_monetario_dolar ( valor NUMBER ) RETURN VARCHAR2 IS


   valor_string  VARCHAR2( 256 );
   valor_conv    VARCHAR2(25);
   ind           NUMBER;
   tres_digitos  VARCHAR2(3);
   texto_string  VARCHAR2(256);

BEGIN
   valor_conv := to_char( trunc((abs(valor) * 100),0) , '0999999999999999999' );
   valor_conv := substr( valor_conv , 1 , 18 ) || '0' || substr( valor_conv , 19, 2 );

   IF UPPER(USER) = 'DBPGY' THEN
      IF to_number( valor_conv ) = 0 THEN
         RETURN( 'CERO ' );
      END IF;
      FOR ind IN 1..7
      LOOP
         tres_digitos := substr( valor_conv , (((ind-1)*3)+1) , 3 );
         texto_string := '' ;
         IF ind <> 7 THEN 
           -- Extenso para Centena
           IF substr(tres_digitos,1,1) = '2' THEN
              texto_string := texto_string || 'DOSCIENTOS ' ;
           ELSIF substr(tres_digitos,1,1) = '3' THEN
              texto_string := texto_string || 'TRESCIENTOS ' ;
           ELSIF substr(tres_digitos,1,1) = '4' THEN
              texto_string := texto_string || 'CUATROCIENTOS ' ;
           ELSIF substr(tres_digitos,1,1) = '5' THEN
              texto_string := texto_string || 'QUINIENTOS ' ;
           ELSIF substr(tres_digitos,1,1) = '6' THEN
              texto_string := texto_string || 'SEISCIENTOS ' ;
           ELSIF substr(tres_digitos,1,1) = '7' THEN
              texto_string := texto_string || 'SETECIENTOS ' ;
           ELSIF substr(tres_digitos,1,1) = '8' THEN
              texto_string := texto_string || 'OCHOCIENTOS ' ;
           ELSIF substr(tres_digitos,1,1) = '9' THEN
              texto_string := texto_string || 'NOVECIENTOS ' ;
           END IF;
           IF substr(tres_digitos,1,1) = '1' THEN
              IF substr(tres_digitos,2,2) = '00' THEN
                 texto_string := texto_string || 'CIEN ' ;
              ELSE
                 texto_string := texto_string || 'CIENTO ' ;
              END IF;
           END IF;
         -- Extenso para Dezena
           IF substr(tres_digitos,2,1) <> '0' AND texto_string IS NOT NULL THEN
              texto_string := texto_string || ' ';
           END IF;
           IF substr(tres_digitos,2,1) = '2' THEN
              texto_string := texto_string ||'VEINTE ';
           ELSIF substr(tres_digitos,2,1) = '3' THEN
              texto_string := texto_string ||'TREINTA ';
           ELSIF substr(tres_digitos,2,1) = '4' THEN
              texto_string := texto_string ||'CUARENTA ';
           ELSIF substr(tres_digitos,2,1) = '5' THEN
              texto_string := texto_string ||'CINCUENTA ';
           ELSIF substr(tres_digitos,2,1) = '6' THEN
              texto_string := texto_string ||'SESENTA ';
           ELSIF substr(tres_digitos,2,1) = '7' THEN
              texto_string := texto_string ||'SETENTA ';
           ELSIF substr(tres_digitos,2,1) = '8' THEN
              texto_string := texto_string ||'OCHENTA ';
           ELSIF substr(tres_digitos,2,1) = '9' THEN
              texto_string := texto_string ||'NOVENTA ';
           END IF;
           IF substr(tres_digitos,2,1) = '1' THEN
              IF substr(tres_digitos,3,1) <> '0' THEN
                 IF substr(tres_digitos,3,1) = '1' THEN
                    texto_string := texto_string ||'ONCE ';
                 ELSIF substr(tres_digitos,3,1) = '2' THEN
                    texto_string := texto_string ||'DOCE ';
                 ELSIF substr(tres_digitos,3,1) = '3' THEN
                    texto_string := texto_string ||'TRECE ';
                 ELSIF substr(tres_digitos,3,1) = '4' THEN
                    texto_string := texto_string ||'CATORCE ';
                 ELSIF substr(tres_digitos,3,1) = '5' THEN
                    texto_string := texto_string ||'QUINCE ';
                 ELSIF substr(tres_digitos,3,1) = '6' THEN
                    texto_string := texto_string ||'DIECISEIS ';
                 ELSIF substr(tres_digitos,3,1) = '7' THEN
                    texto_string := texto_string ||'DIECISIETE ';
                 ELSIF substr(tres_digitos,3,1) = '8' THEN
                    texto_string := texto_string ||'DIECIOCHO ';
                 ELSIF substr(tres_digitos,3,1) = '9' THEN
                    texto_string := texto_string ||'DIECINUEVE ';
                 END IF;
              ELSE
                 texto_string := texto_string ||'DIEZ ' ;
              END IF;
           ELSE
              -- Extenso para Unidade
              IF substr(tres_digitos,3,1) <> '0' AND texto_string IS NOT NULL THEN
                 texto_string := texto_string || 'Y ';
              END IF;
              IF substr(tres_digitos,3,1) = '1' THEN
                 texto_string := texto_string ||'UN ';
              ELSIF substr(tres_digitos,3,1) = '2' THEN
                 texto_string := texto_string ||'DOS ';
              ELSIF substr(tres_digitos,3,1) = '3' THEN
                 texto_string := texto_string ||'TRES ';
              ELSIF substr(tres_digitos,3,1) = '4' THEN
                 texto_string := texto_string ||'CUATRO ';
              ELSIF substr(tres_digitos,3,1) = '5' THEN
                 texto_string := texto_string ||'CINCO ';
              ELSIF substr(tres_digitos,3,1) = '6' THEN
                 texto_string := texto_string ||'SEIS ';
              ELSIF substr(tres_digitos,3,1) = '7' THEN
                 texto_string := texto_string ||'SIETE ';
              ELSIF substr(tres_digitos,3,1) = '8' THEN
                 texto_string := texto_string ||'OCHO ';
              ELSIF substr(tres_digitos,3,1) = '9' THEN
                 texto_string := texto_string ||'NUEVE ';
              END IF;
           END IF;
         ELSE
           IF lpad(to_char(to_number(tres_digitos)),2,'0') <> '00' THEN
              texto_string := lpad(to_char(to_number(tres_digitos)),2,'0')||'/100';
           END IF;
         END IF;
         IF to_number( tres_digitos ) > 0 THEN
            IF to_number( tres_digitos ) = 1 THEN
               IF ind = 1 THEN
                  texto_string := texto_string || 'QUATRILLON ' ;
               ELSIF ind = 2 THEN
                  texto_string := texto_string || 'TRILLHON ' ;
               ELSIF ind = 3 THEN
                  texto_string := texto_string || 'BILLHON ' ;
               ELSIF ind = 4 THEN
                  texto_string := texto_string || 'MILLON ' ;
               ELSIF ind = 5 THEN
                  texto_string := texto_string || 'MIL ' ;
               END IF;
            ELSE
               IF ind = 1 THEN
                  texto_string := texto_string || 'QUATRILLONES ' ;
               ELSIF ind = 2 THEN
                  texto_string := texto_string || 'TRILLHONES ' ;
               ELSIF ind = 3 THEN
                  texto_string := texto_string || 'BILLHONES ' ;
               ELSIF ind = 4 THEN
                  texto_string := texto_string || 'MILLONES ' ;
               ELSIF ind = 5 THEN
                  texto_string := texto_string || 'MIL ' ;
               END IF;
            END IF;
         END IF;
         valor_string := valor_string || texto_string;
         -- Escrita da Moeda Corrente
         IF ind = 5 THEN
             IF to_number( substr( valor_conv , 16 , 3 )) > 0 AND valor_string IS NOT NULL THEN
                valor_string := rtrim(valor_string) || ' ';
             END IF;
         ELSE
            IF ind < 5 AND valor_string IS NOT NULL THEN
               valor_string := rtrim(valor_string) || ' ';
            END IF;
         END IF;
         IF ind = 6 THEN
/*            IF to_number( substr( valor_conv , 1 , 18 ) ) > 1 THEN
               valor_string := valor_string || 'PESOS ';
            ELSIF to_number( substr( valor_conv , 1 , 18 ) ) = 1 THEN
               valor_string := valor_string || 'PESO ';
            END IF;*/
            IF to_number( substr( valor_conv , 20 , 2 ) ) > 0 AND length(valor_string) > 0  THEN
               valor_string := valor_string || 'CON ';
            END IF;
         END IF;
         -- Escrita para Centavos
        /* IF ind = 7 THEN
            IF to_number( substr( valor_conv , 20 , 2 ) ) > 1 THEN
               valor_string := valor_string  || 'CENTAVOS ';
            ELSIF to_number( substr( valor_conv , 20 , 2 ) ) = 1 THEN
               valor_string := valor_string  || 'CENTAVO ';
            END IF;
         END IF;*/
      END LOOP;
----- ATE AQUI
   ELSE
      IF to_number( valor_conv ) = 0 THEN
         RETURN( 'Zero ' );
      END IF;
      FOR ind IN 1..7
      LOOP
         tres_digitos := substr( valor_conv , (((ind-1)*3)+1) , 3 );
         texto_string := '' ;
         -- Extenso para Centena
         IF substr(tres_digitos,1,1) = '2' THEN
            texto_string := texto_string || 'Duzentos ' ;
         ELSIF substr(tres_digitos,1,1) = '3' THEN
            texto_string := texto_string || 'Trezentos ' ;
         ELSIF substr(tres_digitos,1,1) = '4' THEN
            texto_string := texto_string || 'Quatrocentos ' ;
         ELSIF substr(tres_digitos,1,1) = '5' THEN
            texto_string := texto_string || 'Quinhentos ' ;
         ELSIF substr(tres_digitos,1,1) = '6' THEN
            texto_string := texto_string || 'Seiscentos ' ;
         ELSIF substr(tres_digitos,1,1) = '7' THEN
            texto_string := texto_string || 'Setecentos ' ;
         ELSIF substr(tres_digitos,1,1) = '8' THEN
            texto_string := texto_string || 'Oitocentos ' ;
         ELSIF substr(tres_digitos,1,1) = '9' THEN
            texto_string := texto_string || 'Novecentos ' ;
         END IF;
         IF substr(tres_digitos,1,1) = '1' THEN
            IF substr(tres_digitos,2,2) = '00' THEN
               texto_string := texto_string || 'Cem ' ;
            ELSE
               texto_string := texto_string || 'Cento ' ;
            END IF;
         END IF;
       -- Extenso para Dezena
         IF substr(tres_digitos,2,1) <> '0' AND texto_string IS NOT NULL THEN
            texto_string := texto_string || 'e ';
         END IF;
         IF substr(tres_digitos,2,1) = '2' THEN
            texto_string := texto_string ||'Vinte ';
         ELSIF substr(tres_digitos,2,1) = '3' THEN
            texto_string := texto_string ||'Trinta ';
         ELSIF substr(tres_digitos,2,1) = '4' THEN
            texto_string := texto_string ||'Quarenta ';
         ELSIF substr(tres_digitos,2,1) = '5' THEN
            texto_string := texto_string ||'Cinquenta ';
         ELSIF substr(tres_digitos,2,1) = '6' THEN
            texto_string := texto_string ||'Sessenta ';
         ELSIF substr(tres_digitos,2,1) = '7' THEN
            texto_string := texto_string ||'Setenta ';
         ELSIF substr(tres_digitos,2,1) = '8' THEN
            texto_string := texto_string ||'Oitenta ';
         ELSIF substr(tres_digitos,2,1) = '9' THEN
            texto_string := texto_string ||'Noventa ';
         END IF;
         IF substr(tres_digitos,2,1) = '1' THEN
            IF substr(tres_digitos,3,1) <> '0' THEN
               IF substr(tres_digitos,3,1) = '1' THEN
                  texto_string := texto_string ||'Onze ';
               ELSIF substr(tres_digitos,3,1) = '2' THEN
                  texto_string := texto_string ||'Doze ';
               ELSIF substr(tres_digitos,3,1) = '3' THEN
                  texto_string := texto_string ||'Treze ';
               ELSIF substr(tres_digitos,3,1) = '4' THEN
                  texto_string := texto_string ||'Catorze ';
               ELSIF substr(tres_digitos,3,1) = '5' THEN
                  texto_string := texto_string ||'Quinze ';
               ELSIF substr(tres_digitos,3,1) = '6' THEN
                  texto_string := texto_string ||'Dezesseis ';
               ELSIF substr(tres_digitos,3,1) = '7' THEN
                  texto_string := texto_string ||'Dezessete ';
               ELSIF substr(tres_digitos,3,1) = '8' THEN
                  texto_string := texto_string ||'Dezoito ';
               ELSIF substr(tres_digitos,3,1) = '9' THEN
                  texto_string := texto_string ||'Dezenove ';
               END IF;
            ELSE
               texto_string := texto_string ||'Dez ' ;
            END IF;
         ELSE
         -- Extenso para Unidade
            IF substr(tres_digitos,3,1) <> '0' AND texto_string IS NOT NULL THEN
               texto_string := texto_string || 'e ';
            END IF;
            IF substr(tres_digitos,3,1) = '1' THEN
               texto_string := texto_string ||'Um ';
            ELSIF substr(tres_digitos,3,1) = '2' THEN
               texto_string := texto_string ||'Dois ';
            ELSIF substr(tres_digitos,3,1) = '3' THEN
               texto_string := texto_string ||'Tres ';
            ELSIF substr(tres_digitos,3,1) = '4' THEN
               texto_string := texto_string ||'Quatro ';
            ELSIF substr(tres_digitos,3,1) = '5' THEN
               texto_string := texto_string ||'Cinco ';
            ELSIF substr(tres_digitos,3,1) = '6' THEN
               texto_string := texto_string ||'Seis ';
            ELSIF substr(tres_digitos,3,1) = '7' THEN
               texto_string := texto_string ||'Sete ';
            ELSIF substr(tres_digitos,3,1) = '8' THEN
               texto_string := texto_string ||'Oito ';
            ELSIF substr(tres_digitos,3,1) = '9' THEN
               texto_string := texto_string ||'Nove ';
            END IF;
         END IF;
         IF to_number( tres_digitos ) > 0 THEN
            IF to_number( tres_digitos ) = 1 THEN
               IF ind = 1 THEN
                  texto_string := texto_string || 'Quatrilhao ' ;
               ELSIF ind = 2 THEN
                  texto_string := texto_string || 'Trilhao ' ;
               ELSIF ind = 3 THEN
                  texto_string := texto_string || 'Bilhao ' ;
               ELSIF ind = 4 THEN
                  texto_string := texto_string || 'Milhao ' ;
               ELSIF ind = 5 THEN
                  texto_string := texto_string || 'Mil ' ;
               END IF;
            ELSE
               IF ind = 1 THEN
                  texto_string := texto_string || 'Quatrilhoes ' ;
               ELSIF ind = 2 THEN
                  texto_string := texto_string || 'Trilhoes ' ;
               ELSIF ind = 3 THEN
                  texto_string := texto_string || 'Bilhoes ' ;
               ELSIF ind = 4 THEN
                  texto_string := texto_string || 'Milhoes ' ;
               ELSIF ind = 5 THEN
                  texto_string := texto_string || 'Mil ' ;
               END IF;
            END IF;
         END IF;
         valor_string := valor_string || texto_string;
         -- Escrita da Moeda Corrente
         IF ind = 5 THEN
             IF to_number( substr( valor_conv , 16 , 3 )) > 0 AND valor_string IS NOT NULL THEN
                valor_string := rtrim(valor_string) || ', ';
             END IF;
         ELSE
            IF ind < 5 AND valor_string IS NOT NULL THEN
               valor_string := rtrim(valor_string) || ', ';
            END IF;
         END IF;
         IF ind = 6 THEN
            IF to_number( substr( valor_conv , 1 , 18 ) ) > 1 THEN
               valor_string := valor_string || 'Reais ';
            ELSIF to_number( substr( valor_conv , 1 , 18 ) ) = 1 THEN
               valor_string := valor_string || 'Real ';
            END IF;

            IF to_number( substr( valor_conv , 20 , 2 ) ) > 0 AND length(valor_string) > 0  THEN
               valor_string := valor_string || 'e ';
            END IF;
         END IF;
         -- Escrita para Centavos
         IF ind = 7 THEN
            IF to_number( substr( valor_conv , 20 , 2 ) ) > 1 THEN
               valor_string := valor_string  || 'Centavos ';
            ELSIF to_number( substr( valor_conv , 20 , 2 ) ) = 1 THEN
               valor_string := valor_string  || 'Centavo ';
            END IF;
         END IF;
      END LOOP;
   END IF;

   RETURN( 'DOLARES '||rtrim(valor_string) );

EXCEPTION
   WHEN OTHERS THEN RETURN( '*** VALOR INVALIDO ***' );

END cpd_fextenso_monetario_dolar;
/
