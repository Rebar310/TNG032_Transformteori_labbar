%% Uppgift 1

% Definiera värden på a
a_values = [8, 14, 30];

% Skapa en figur för alla stegresponskurvor
figure;
hold on;

% Loop genom varje a-värde
for i = 1:length(a_values)
    a = a_values(i);
    
    % Definiera täljare och nämnare för överföringsfunktionen
    T = [a];          % Täljare
    N = [1, 2, a];    % Nämnare
    SYS = tf(T, N);   % Skapa system
    
    % Rita stegsvaret
    [y, t] = step(SYS);  % Beräkna stegsvaret
    plot(t, y, 'DisplayName', ['a = ' num2str(a)]); 
    
    % Hitta stigtiden (tid från 10% till 90% av slutvärdet)
    y_final = y(end); % Slutvärdet på stegsvaret
    t_10 = t(find(y >= 0.1 * y_final, 1)); % Tid vid 10% av slutvärdet
    t_90 = t(find(y >= 0.9 * y_final, 1)); % Tid vid 90% av slutvärdet
    rise_time = t_90 - t_10; % Beräkna stigtiden
    
    % Skriv ut resultatet i MATLAB:s kommandofönster
    fprintf('Då a = %d, är stigtiden ungefär %.3f sekunder.\n', a, rise_time);
end

% Formatera grafen
xlabel('Tid (s)');
ylabel('Utsignal y(t)');
title('Stegsvar för olika värden på a');
legend;
grid on;
hold off;


% svar: 
% då a = 8 , är stigtiden 0.507 sek
% då a = 14 , -//- 0.368 sek
% då a = 30 , -//- 0.230 sek

% Uppgift 2 ---------------------------------------------

% svar : ja 

% Stegsvaren och expsin-funktionerna visar båda oscillerande beteenden,
% men med vissa skillnader. Stegsvaren är mer dämpade och når sitt slutvärde snabbare vid högre 
% a-värden, medan expsin-funktionen har mer markerade svängningar eftersom dess frekvens beror direkt på 
% b = a−1 . Stegsvaren stabiliseras snabbare, medan expsin-funktionen kan ha mer utdragna svängningar. 
% Dessa skillnader gör att figurerna ser olika ut.






