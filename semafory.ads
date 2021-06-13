package Semafory is			 
						
  type Wart_binarna is range 0..1;
  protected type Semafor_binarny(Wart_poczatkowa: Wart_binarna := 0) is
    entry PB;          	-- opuszczenie semafora
    procedure VB;     	-- podniesienie semafora
  private
    Wart: Wart_binarna := Wart_poczatkowa;
  end Semafor_binarny;

end Semafory;
