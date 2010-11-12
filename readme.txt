psgroove modified by Hermes

This code is the result to disassemble port1_config_descriptor and to get some things from AerialX code

It have some features news:

- You can launch an EBOOT.BIN (unencrypted) from /dev_usb000 using the menu option "/app_home/PS3_GAME".
You must copy in the root folder of the USB device a PS3_GAME folder with the next content

PS3GAME
|------- USRDIR ---->EBOOT.BIN
|------- ICON0.PNG
|------- PARAM.SFO

- You can also launch backups using a manager. The original manager needs a Bluray disc to exit and run games, but i have added a new 
feature to create a shortcut between "/app_home/PS3_GAME" and /dev_bdvd. So, it is possible to launch games without a bluray disc 
in the tray, using this path (but you needs other manager or you needs eject the disc after leaving the original manager).

I have tested some games, as Uncharted 2, Heavently Sword and others, mounting it directly (in payload the code) and it works without any disc

Aditional notes:

Te syscall 36 is used to indicate the game path and it is used to create the shortcut detecting a pointer in the payload . I have relocated 
"memory_patch_table" because the dedicated area is full and it hang if you copy more code.

To compile the PPU code you needs the compilers created by the ps3toolchain and fix the path in PS3_COMPILERS from Makefile.payload. You needs also
the AVR compilers (i use an AT90USBKEY) and maybe gcc compiler (for raw2payload utility in others system)

If you are using a PIC or other method, use port1_config_descriptor.h to replace the same thing.


---------------------------------------------------------------------------------------------------------------------------------------------------------

Este código es el resultado de desesamblar port1_config_descriptor y de tomar algunas cosas del código publicado de AerialX

It tiene algunas funciones nuevas:

- Puedes lanzar un EBOOT.BIN (sin encriptar) desde /dev_usb000 (el puerto USB mas a la derecha en mi modelo) usando la opción en el menu 
"/app_home/PS3_GAME". Debes copiar la carpeta PS3_GAME en el directorio raíz  con el siguiente contenido:

PS3GAME
|------- USRDIR ---->EBOOT.BIN
|------- ICON0.PNG
|------- PARAM.SFO

- Tambien puedes lanzar backups usando un manager. El original necesita un disco Bluray para salir y correr juegos, pero yo he añadido una nueva opción 
que crea una comunicación entre "/app_home/PS3_GAME" y /dev_bdvd. Eso hace posible lanzar juegos sin tener un disco bluray en la bandeja, usando éste 
camino (pero necesitas otro manager o expulsar el disco después de salir del manager original)

I he probado algunos juegos, como Uncharted 2, Heavenly Swords y otros, montando directamente (en el código del payload) y ello funciona perfectamente
sin necesidad de disco en los juegos que he podido probar (se acabó que un disco olvidado te corte el dedo. Al menos, con los juegos que he probado XD)

Notas adicionales:

La syscall 36 pasa la ruta del juego y eso se usa para provocar la comunicación entre ambos métodos (por la asignación de un puntero), como es obvio. 
He relocalizado una tabla de parches porque parece que el código es excesivo en su posición original y provoca un cuelgue si copias mas código.

Para compilar el código PPU, necesitas los compiladores que te crea la ps3toolchain  y fijar la ruta correcta en Makefile.payload (PS3_COMPILERS), 
aparte de los compiladores de AVR (en mi caso, está compilado para una AT90USBKEY).

Si estás usando un PIC u otro método, tan solo tienes que pasar port1_config_descriptor.h a tu proyecto. La utilidad raw2payload.exe, está compilada 
utilizando cygwin. Si necesitas compilarla por tu cuenta, puedes modificar el Makefile.payload para que use tu compilador gcc.