package body Semafory is		
						
  protected body Semafor_binarny is
 
    entry PB when Wart = 1 is
    begin
      Wart := 0;
    end PB; 

    procedure VB is
    begin
      if Wart = 0 then Wart := 1; end if;
    end VB;

  end Semafor_binarny;
end Semafory;
