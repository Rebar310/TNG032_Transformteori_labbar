%% Laborationsuppgift 1

svar1 = manhat(3,0,9,1)
svar2 = manhat(-3,7,-9,5)

%% Laborationsuppgift 2 

bild = imread('lamb.png');

% När bilden lästs in så lagrades bilddatan i minnet som uint8 (unsigned 8-bit integer), 
% vilket ej är lämpligt till vidare arbete. Därmed ska bildens datatyp ändras till 
% double (64-bitars flyttal) och värden skalas ner:
bild = double(bild)/ 225;

% Steg 3: Visa bilden
figure;
imshow(bild); % Visa den skalade bilden
title('Originalbild');

% Steg 4:Fouriertransformera bilden och spara spektrumet i variablen spektrum
spektrum = fft2(bild); 

% Steg 5: Visa bildens amplitudspektrum i logaritmisk skala
figure;
imagesc(log1p(abs(spektrum))); % Logaritmisk skala för amplitudspektrumet
colormap(gray); % Använd gråskala (kan ändras till bone, copper, pink, etc.)
%colorbar; % Lägg till färgskala
axis image; % Korrigera koordinatskalning
title('Amplitudspektrum');

% Steg 6: Tillämpa fftshift på spektrumet
spektrumSkiftat = fftshift(spektrum); % Flytta lågfrekvenser till mitten

% Steg 7: Visa skiftat amplitudspektrum i ett separat figurfönster
figure;
imagesc(log1p(abs(spektrumSkiftat))); % Logaritmisk skala för skiftat spektrum
colormap(gray); % Använd gråskala
%colorbar; % Lägg till färgskala
axis image; % Korrigera koordinatskalning
title('Skiftat amplitudspektrum');

% Steg 8: Spara skiftat amplitudspektrum i en PNG-fil
imwrite(rescale(log1p(abs(spektrumSkiftat))), 'lambSpektrum.png'); % Spara bilden
disp('Skiftat amplitudspektrum sparat som "lambSpektrum.png".');


%% Laborationsuppgift 3

% Skapa en 16x16 matris
storlek = 16; % Dimensionen på matrisen
avstandskarta = zeros(storlek, storlek); % Initiera matrisen

% Beräkna Manhattan-avstånd till elementet på (9, 9)
for r = 1:storlek
    for k = 1:storlek
        avstandskarta(r, k) = manhat(r,k,9,9);
    end
end

% Visa avståndskartan
figure;
imagesc(avstandskarta); % Visualisera matrisen
colormap(gray); % Använd gråskala
colorbar; % Lägg till en färgskala
axis image; % Bevara pixelproportioner
title('Manhattan-avståndskarta (16x16)');

% För att kunna svara på frågorna korrekt
a = manhat(16,8,9,9)
b = manhat(16,10,9,9)
c = manhat(3,16,9,9)

%% Laborationsuppgift 4

% Läs in bilden och justera datatyp och skalning
bild = double(imread('ekollon.png')) / 255;

% Visa originalbilden
figure;
imshow(bild);
title('Originalbild');

% Bildens storlek
storlek = size(bild, 1); % Antas vara 16x16

% Skapa Manhattan-avståndskarta
avstandskarta = zeros(storlek, storlek);
for r = 1:storlek
    for k = 1:storlek
        avstandskarta(r, k) = manhat(r, k, 9, 9); 
    end
end

% Fouriertransformera och skifta spektrumet
spektrum = fft2(bild);
spektrumSkiftat = fftshift(spektrum);

% Loop för olika tröskelvärden
for k = 0:max(avstandskarta(:))
    % Skapa mask för det aktuella tröskelvärdet
    mask = (avstandskarta <= k);

    % Filtrera det skiftade spektrumet med masken
    spektrumSkiftatFiltrerat = spektrumSkiftat .* mask;

    % Skifta tillbaka och inverstransformera
    spektrumFiltrerat = ifftshift(spektrumSkiftatFiltrerat);
    bildFiltrerad = ifft2(spektrumFiltrerat);

    % Visa originalbild, filtrerad bild och differensbild i en figur
    figure;
    subplot(1, 3, 1);
    imshow(bild);
    title('Originalbild');
    
    subplot(1, 3, 2);
    imshow(real(bildFiltrerad));
    title(['Filtrerad bild (k = ', num2str(k), ')']);
    
    subplot(1, 3, 3);
    imagesc(abs(bild - real(bildFiltrerad)));
    colormap('gray');
    colorbar;
    axis image;
    title('Differensbild');

    % Paus för att visualisera varje iteration
    pause(1);
end

%% Laborationsuppgift 5

% Läs in bilden och justera datatyp och skalning
bildOrig = double(imread('img15.png')) / 255;

% Initialisera variabler för spektrum och filtrerad bild
spektrum = complex(zeros(size(bildOrig))); % Komplext spektrum
bildFiltrerad = zeros(size(bildOrig));     % Filtrerad bild

% Skapa en avståndskarta för en 16x16 delbild med (9,9) som centrum
storlekDelbild = 16; % Storlek på delbilder
avstandskarta = zeros(storlekDelbild, storlekDelbild);
for r = 1:storlekDelbild
    for k = 1:storlekDelbild
        avstandskarta(r, k) = manhat(r, k, 9, 9); 
    end
end

% Steg 1: Fouriertransformera varje delbild och flytta nollfrekvenskomponenten
for delbildRad = 1:16:size(bildOrig, 1)-15
    for delbildKol = 1:16:size(bildOrig, 2)-15
        % Extrahera en 16x16 delbild
        delbild = bildOrig(delbildRad:delbildRad+15, delbildKol:delbildKol+15);
        % Fouriertransformera och flytta nollfrekvensen
        delbildSpektrumSkiftat = fftshift(fft2(delbild));
        % Spara det skiftade spektrumet
        spektrum(delbildRad:delbildRad+15, delbildKol:delbildKol+15) = delbildSpektrumSkiftat;
    end
end

% Steg 2: Prova olika tröskelvärden
for troskel = 0:max(avstandskarta(:)) % Loop över olika tröskelvärden
    % Skapa en mask baserat på tröskelvärdet
    mask = avstandskarta <= troskel; % Behåll koefficienter inom tröskelavstånd

    % Bearbeta varje delbild igen
    for delbildRad = 1:16:size(spektrum, 1)-15
        for delbildKol = 1:16:size(spektrum, 2)-15
            % Plocka fram spektrum för aktuell delbild
            delbildSpektrumSkiftat = spektrum(delbildRad:delbildRad+15, delbildKol:delbildKol+15);
            % Maskera spektrumet
            delbildSpektrumMaskerat = delbildSpektrumSkiftat .* mask;
            % Flytta tillbaka nollfrekvensen
            delbildSpektrum = ifftshift(delbildSpektrumMaskerat);
            % Inverstransformera för att få den filtrerade delbilden
            delbildFiltrerad = ifft2(delbildSpektrum);
            % Spara den filtrerade delbilden på rätt plats
            bildFiltrerad(delbildRad:delbildRad+15, delbildKol:delbildKol+15) = real(delbildFiltrerad);
        end
    end

    % Visa originalbild och filtrerad bild
    subplot(1, 2, 1); imshow(bildOrig);
    title('Originalbild');
    subplot(1, 2, 2); imshow(bildFiltrerad);
    title(['Komprimerad bild med k=', num2str(troskel)]);

    % Spara den filtrerade bilden som PNG-fil
    imwrite(bildFiltrerad, ['img15_troskel', num2str(troskel, '%02d'), '.png']);

    % Uppdatera grafiken och pausa
    drawnow;
    pause(2);
end

%% Delfrågan under labuppgift 5
% Skapa Manhattan-avståndskarta för en 16x16 matris
storlek = 16; % Matrisstorlek
avstandskarta = zeros(storlek, storlek);
for r = 1:storlek
    for k = 1:storlek
        avstandskarta(r, k) = manhat(r, k, 9, 9); 
    end
end

% Tröskelvärde k=3
k = 3;
mask = (avstandskarta <= k); % Skapa mask för k=3

% Rita ut masken
figure;
imagesc(mask); % Rita ut matrisen
colormap(gray); % Använd gråskala
axis image; % Bevara proportionerna
colorbar; % Lägg till en färgskala
title('Mask för k = 3');

%% sista deluppgiften under lab4

% Skapa Manhattan-avståndskarta för en 16x16 matris
storlek = 16; % Matrisstorlek
avstandskarta = zeros(storlek, storlek);
for r = 1:storlek
    for k = 1:storlek
        avstandskarta(r, k) = manhat(r, k, 9, 9); 
    end
end

% För olika tröskelvärden, beräkna antal nollskilda element i masken
for k = [1, 3]
    mask = (avstandskarta <= k); % Skapa mask för tröskelvärdet k
    antal_bevarade = nnz(mask); % Antal nollskilda element i masken
    antal_forkastade = numel(mask) - antal_bevarade; % Total - bevarade
    
    % Skriv ut resultatet
    fprintf('Tröskelvärde k = %d:\n', k);
    fprintf('  Fourierkoefficienter som bevaras: %d\n', antal_bevarade);
    fprintf('  Fourierkoefficienter som förkastas: %d\n\n', antal_forkastade);
end
