-- 3/2/3/4/3/F moj wariant

with Text_IO; use Text_IO;
with stosPackage; use stosPackage;
with Semafory; use Semafory;
with Ada.Calendar;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;


procedure Main is
   capacity:Integer:=25;          -- wielkosc bufora
   task type Serwer(id: Integer);  -- serwer z parameterm
   task type Klient(id:Integer);   -- klient z parametrem
   task type Posrednik(id:Integer);   -- deklaracja zadania posrednika z parametrem

   Buff:Access stosStruktura;  -- deklaracja pointera dla bufora
   Sem:Access Semafor_Binarny; -- deklaracja piontera dla semafora glownego
   SemE:Access Semafor_Binarny; -- deklaracja piontera dla semafora Pusty
   SemF:Access Semafor_Binarny; -- deklaracja piontera dla semafora Pelnego

   -- deklaracje buforow i przypisanych im semaforow
   --seafory wejscia
   
   B11:Aliased stosStruktura(capacity);
   Sem11:Aliased Semafor_Binarny(1);
   Sem11Empty:Aliased Semafor_binarny(1);
   Sem11Full:Aliased Semafor_binarny(1);

   B12:Aliased stosStruktura(capacity);
   Sem12:Aliased Semafor_Binarny(1);
   Sem12Empty:Aliased Semafor_binarny(1);
   Sem12Full:Aliased Semafor_binarny(1);

   --semafory wyjscia
   
   B21:Aliased stosStruktura(capacity);
   Sem21:Aliased Semafor_Binarny(1);
   Sem21Empty:Aliased Semafor_binarny(1);
   Sem21Full:Aliased Semafor_binarny(1);

   B22:Aliased stosStruktura(capacity);
   Sem22:Aliased Semafor_Binarny(1);
   Sem22Empty:Aliased Semafor_binarny(1);
   Sem22Full:Aliased Semafor_binarny(1);

   B23:Aliased stosStruktura(capacity);
   Sem23:Aliased Semafor_Binarny(1);
   Sem23Empty:Aliased Semafor_binarny(1);
   Sem23Full:Aliased Semafor_binarny(1);

   B24:Aliased stosStruktura(capacity);
   Sem24:Aliased Semafor_Binarny(1);
   Sem24Empty:Aliased Semafor_binarny(1);
   Sem24Full:Aliased Semafor_binarny(1);

   -- koniec deklaracji buforow i semaforow

   -- tablica prawdopodobienstwa dla S/B/K
   T: array (1..9, 1..6) of Float := ((0.4,0.6,0.0,0.0,0.0,0.0),
                                      (0.1,0.9,0.0,0.0,0.0,0.0),
                                      (0.5,0.5,0.0,0.0,0.0,0.0),
                                      (0.5,0.5,0.1,0.2,0.3,0.4),
                                      (0.75,0.25,0.09,0.19,0.29,0.43),
                                      (0.1,0.9,0.11,0.18,0.2,0.51),
                                      (0.08,0.22,0.31,0.39,0.0,0.0),
                                      (0.1,0.2,0.3,0.4,0.0,0.0),
                                      (0.09,0.19,0.29,0.43,0.0,0.0));
   
   -- tablica dwuwymiarowa - zawiera prawdopodobienstwa, ktore musza sie sumowac do 1
   -- cialo zadania Serwer
   task body Serwer is -- definicja zachowania serwera
      idw:Integer;
      z:Integer; --z - numer wybanego bufora
      x:Float; -- x - wg zadania liczba przenoszona
      p:Float;  -- prawdopodobienstwo mniejsze niz 1 i suma laczna musi byc 1
      G:Generator;
      time:Float;
   begin
      Reset(G);
      idw:=id; -- przypisanie numeru serwera
      loop
         x := Float(Random(G)*1.0); -- generowanie losowej liczby Float
         --Put_Line("<<--- Serwer "&Integer'Image(idw)&" wygenerowal liczbe: "&Integer'Image(x));
         -- serwer wstawil do bufora liczbe - strzalka z dwoma grotami w jedna str oznacza sie udalo, po wstawieniu nastepuje odblokowanie bufora 
         Time:=Random(G) * 100.0;  -- ustawianie czasu opoznienia, random (G) da liczbe 0-1, dalej mnozymy x 100
         Delay(Duration(Time));  -- opoznienie, wyl proces aktywnosci przez odcinek o wartosci time,
         p:=Random(G);  -- generowanie liczny Float prawdopodobienstwa

         if idw = 1 then  -- dla serwera 1
            if p <= T(1,1) then
               Buff:=B11'Access;
               Sem:=Sem11'Access;
               SemE:=Sem11Empty'Access;
               SemF:=Sem11Full'Access;
               z:=11;

            elsif p<=(T(1,1) + T(1,2)) then
               Buff:=B12'Access;
               Sem:=Sem12'Access;
               SemE:=Sem12Empty'Access;
               SemF:=Sem12Full'Access;
               z:=12;

         elsif idw = 2 then
            if p <= T(2,1) then
               Buff:=B11'Access;
               Sem:=Sem11'Access;
               SemE:=Sem11Empty'Access;
               SemF:=Sem11Full'Access;
               z:=11;

            elsif p<=(T(2,1) + T(2,2)) then
               Buff:=B12'Access;
               Sem:=Sem12'Access;
               SemE:=Sem12Empty'Access;
               SemF:=Sem12Full'Access;
               z:=12;

            end if;
      elsif idw = 3 then
            if p <= T(3,1) then
               Buff:=B11'Access;
               Sem:=Sem11'Access;
               SemE:=Sem11Empty'Access;
               SemF:=Sem11Full'Access;
               z:=11;

            elsif p<=(T(3,1) + T(3,2)) then
               Buff:=B12'Access;
               Sem:=Sem12'Access;
               SemE:=Sem12Empty'Access;
               SemF:=Sem12Full'Access;
               z:=12;
            end if;

      end if;

      -- Put_line("<<-->> Serwer"&integer'image(idw)& " wybral bufor " &integer'image(z));

      if pelny(Buff) then
              Put_line("<<--x Serwer "&integer'image(idw)&" trafil na pelny bufor ["&integer'image(z)&"].");
              SemF.PB; --opuszczenie/blokada bufora
            -- symbol <<--x oznacza ze sie nie udalo, bo bufor byl pelny, x oznacza nie udalo sie 
            else
              Sem.PB;
              wstaw(Buff,x); -- pobieranie liczby float z bufora (?)
              -- a tutaj ten symbol <<--- oznacza sie sie udalo
              Put_line("<<--- Serwer "&integer'image(idw)&" wstawil do bufora ["&integer'image(z)&"] liczbe '"&Float'image(x)&"' i odwiesza semafor bufora.");
              Sem.VB;
              SemE.VB; -- podnisienie/odblokowanie bufora
            end if;
            Reset(G);
       end if;
   end loop;
end Serwer;

task body Posrednik is
idw, z:Integer;
x:Float;
p:Float;
G:Generator;
time:Float;
begin
  idw:=id;
  Reset(G,idw);
  loop
    Time:=Random(G) * 5.0;
    Delay(Duration(Time));
    p:=Random(G);
    if idw = 1 then
          if p <= T(4,1) then
               Buff:=B11'Access;
               Sem:=Sem11'Access;
               SemE:=Sem11Empty'Access;
               SemF:=Sem11Full'Access;
               z:=11;

            elsif p<=(T(4,1) + T(4,2)) then
               Buff:=B12'Access;
               Sem:=Sem12'Access;
               SemE:=Sem12Empty'Access;
               SemF:=Sem12Full'Access;
                  z:=12;

            end if;

         elsif idw = 2 then
            if p <= T(5,1) then
               Buff:=B11'Access;
               Sem:=Sem11'Access;
               SemE:=Sem11Empty'Access;
               SemF:=Sem11Full'Access;
               z:=11;

            elsif p<=(T(5,1) + T(5,2)) then
               Buff:=B12'Access;
               Sem:=Sem12'Access;
               SemE:=Sem12Empty'Access;
               SemF:=Sem12Full'Access;
               z:=12;

            end if;

         elsif idw = 3 then
            if p <= T(6,1) then
               Buff:=B11'Access;
               Sem:=Sem11'Access;
               SemE:=Sem11Empty'Access;
               SemF:=Sem11Full'Access;
               z:=11;

            elsif p<=(T(6,1) + T(6,2)) then
               Buff:=B12'Access;
               Sem:=Sem12'Access;
               SemE:=Sem12Empty'Access;
               SemF:=Sem12Full'Access;
               z:=12;

            end if;
    end if;

    -- Put_line("<<->> Posrednik "&integer'image(idw)&" wybral bufor do pobrania ["&integer'image(z)&"]");

        if Pusty(Buff) then
          Put_line("<<x>> Posrednik "&integer'image(idw)&" chcial pobrac i trafil na pusty bufor ["&integer'image(z)&"].");
          SemE.PB;
        -- symbol oznacza <<x>> ze sie nie udalo, trafilo na pusty bufor 
         else
          Sem.PB;
          pobierz(Buff,x);
          Put_line("<<->> Posrednik "&integer'image(idw)&" pobral z bufora ["&integer'image(z)&"] liczbe '"&Float'image(x)&"' i odwiesza semafor bufora.");
          -- symbol <<->> oznacza ze sie udalo, bufor odwieszony VB
          Sem.VB;
          SemF.VB;
        end if;
       Time:=Random(G) * 5.0;
       Delay(Duration(Time));
       p:=Random(G);

         if idw = 1 then
            if p <= T(4,3) then
               Buff:=B21'Access;
               Sem:=Sem21'Access;
               SemE:=Sem21Empty'Access;
               SemF:=Sem21Full'Access;
               z:=21;

            elsif p<=(T(4,3) + T(4,4)) then
               Buff:=B22'Access;
               Sem:=Sem22'Access;
               SemE:=Sem22Empty'Access;
               SemF:=Sem22Full'Access;
               z:=22;

            elsif p<=(T(4,4) + T(4,5) + T(4,6)) then
               Buff:=B23'Access;
               Sem:=Sem23'Access;
               SemE:=Sem23Empty'Access;
               SemF:=Sem23Full'Access;
               z:=23;

            else
               Buff:=B24'Access;
               Sem:=Sem24'Access;
               SemE:=Sem24Empty'Access;
               SemF:=Sem24Full'Access;
               z:=24;
            end if;

         elsif idw = 2 then
            if p <= T(5,1) then
               Buff:=B21'Access;
               Sem:=Sem21'Access;
               SemE:=Sem21Empty'Access;
               SemF:=Sem21Full'Access;
               z:=21;

            elsif p<=(T(5,3) + T(5,4)) then
               Buff:=B22'Access;
               Sem:=Sem22'Access;
               SemE:=Sem22Empty'Access;
               SemF:=Sem22Full'Access;
               z:=22;

            elsif p<=(T(5,4) + T(5,5) + T(5,6)) then
               Buff:=B23'Access;
               Sem:=Sem23'Access;
               SemE:=Sem23Empty'Access;
               SemF:=Sem23Full'Access;
               z:=23;

            else
               Buff:=B24'Access;
               Sem:=Sem24'Access;
               SemE:=Sem24Empty'Access;
               SemF:=Sem24Full'Access;
               z:=24;
            end if;

         elsif idw = 3 then
            if p <= T(6,3) then
               Buff:=B21'Access;
               Sem:=Sem21'Access;
               SemE:=Sem21Empty'Access;
               SemF:=Sem21Full'Access;
               z:=21;

            elsif p<=(T(6,3) + T(6,4)) then
               Buff:=B22'Access;
               Sem:=Sem22'Access;
               SemE:=Sem22Empty'Access;
               SemF:=Sem22Full'Access;
               z:=22;

            elsif p<=(T(6,4) + T(6,5) + T(6,6)) then
               Buff:=B23'Access;
               Sem:=Sem23'Access;
               SemE:=Sem23Empty'Access;
               SemF:=Sem23Full'Access;
               z:=23;

            else
               Buff:=B24'Access;
               Sem:=Sem24'Access;
               SemE:=Sem24Empty'Access;
               SemF:=Sem24Full'Access;
               z:=24;
            end if;

      end if;

      -- Put_line("<<->> Posrednik "&integer'image(idw)& " wybral do wstawienia bufor ["&integer'image(z)&"]");

      if pelny(Buff) then
              Put_line("<<x>> Posrednik "&integer'image(idw)&" chcial wstawic do pelnego bufora ["&integer'image(z)&"].");
              SemF.PB;
            else
              Sem.PB;
              wstaw(Buff,x);
              Put_line("<<->> Posrednik "&integer'image(idw)&" wstawil do bufora ["&integer'image(z)&"] liczbe '"&Float'image(x)&"' i odwiesza semafor bufora.");
              Sem.VB;
              SemE.VB;
            end if;
    Reset(G);
    end loop;
   end Posrednik;
   
   -- idw - identyfikator w, ponizej jest deklaracja ze id = idw, do idw mamy przypisane warianty: 1, 2, 3 ponizej co sie wykonuje dla danej opcji (np. ponizej 1)
   
task body Klient is
idw, z:Integer;
x:Float;
p:Float;
G:Generator;
time:Float;
begin
  idw:=id;
  Reset(G);
  loop
    Time:=Random(G) * 10.0;
    Delay(Duration(Time));
    p:=Random(G);
    if idw = 1 then
          if p <= T(7,1) then
               Buff:=B21'Access;
               Sem:=Sem21'Access;
               SemE:=Sem21Empty'Access;
               SemF:=Sem21Full'Access;
               z:=21;

            elsif p<=(T(7,1) + T(7,2)) then
               Buff:=B22'Access;
               Sem:=Sem22'Access;
               SemE:=Sem22Empty'Access;
               SemF:=Sem22Full'Access;
               z:=22;

            elsif p<=(T(7,1) + T(7,2) + T(7,3)) then
               Buff:=B23'Access;
               Sem:=Sem23'Access;
               SemE:=Sem23Empty'Access;
               SemF:=Sem23Full'Access;
               z:=23;

            else
               Buff:=B24'Access;
               Sem:=Sem24'Access;
               SemE:=Sem24Empty'Access;
               SemF:=Sem24Full'Access;
               z:=24;
            end if;

         elsif idw = 2 then
            if p <= T(8,1) then
               Buff:=B21'Access;
               Sem:=Sem21'Access;
               SemE:=Sem21Empty'Access;
               SemF:=Sem21Full'Access;
               z:=21;

            elsif p<=(T(8,1) + T(8,2)) then
               Buff:=B22'Access;
               Sem:=Sem22'Access;
               SemE:=Sem22Empty'Access;
               SemF:=Sem22Full'Access;
               z:=22;

            elsif p<=(T(8,1) + T(8,2) + T(8,3)) then
               Buff:=B23'Access;
               Sem:=Sem23'Access;
               SemE:=Sem23Empty'Access;
               SemF:=Sem23Full'Access;
               z:=23;

            else
               Buff:=B24'Access;
               Sem:=Sem24'Access;
               SemE:=Sem24Empty'Access;
               SemF:=Sem24Full'Access;
               z:=24;
            end if;

         elsif idw = 3 then
            if p <= T(9,1) then
               Buff:=B21'Access;
               Sem:=Sem21'Access;
               SemE:=Sem21Empty'Access;
               SemF:=Sem21Full'Access;
               z:=21;

            elsif p<=(T(9,1) + T(9,2)) then
               Buff:=B22'Access;
               Sem:=Sem22'Access;
               SemE:=Sem22Empty'Access;
               SemF:=Sem22Full'Access;
               z:=22;

            elsif p<=(T(9,1) + T(9,2) + T(9,3)) then
               Buff:=B23'Access;
               Sem:=Sem23'Access;
               SemE:=Sem23Empty'Access;
               SemF:=Sem23Full'Access;
               z:=23;

            else
               Buff:=B24'Access;
               Sem:=Sem24'Access;
               SemE:=Sem24Empty'Access;
               SemF:=Sem24Full'Access;
               z:=24;
            end if;
    end if;

    -- Put_line("--->> Klient "&integer'image(idw)&" wybral bufor ["&integer'image(z)&"]");

        if Pusty(Buff) then
          Put_line("x-->> Klient "&integer'image(idw)&" chcial pobrac z pustego bufora ["&integer'image(z)&"].");
          SemE.PB;
        else
          Sem.PB;
          pobierz(Buff,x);
          Put_line("--->> Klient "&integer'image(idw)&" pobral z bufora ["&integer'image(z)&"] liczbe "&Float'image(x)&" i odwiesza semafor bufora.");
          Sem.VB;
          SemF.VB;
        end if;
    Reset(G);
    end loop;
end Klient;

  
   -- procedura wywolania zadan dla serwera/posrednika/klienta, przypisanie id 

S1:Serwer(id=>1);
S2:Serwer(id=>2);
S3:Serwer(id=>3);
B1:Posrednik(id=>1);
B2:Posrednik(id=>2);
B3:Posrednik(id=>3);
K1:Klient(id=>1);
K2:Klient(id=>2);
K3:Klient(id=>3);

begin
   null; -- null pusta instrukcja 
end Main;
