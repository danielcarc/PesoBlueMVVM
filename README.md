Es una app para consultar el valor del Dolar Oficial y Blue, Euro Blue, Real y demas monedas. 
Tambien posee una calculadora para calcular segun un monto en una moneda su equivalente en Pesos Arg.
Es una app enteramente diseñada en UI Programatica
Comenzamos con UITabBarController donde la primer View que nos muestra el valor en tiempo real de Monedas como el Dolar Oficial, el Dolar Blue y el Euro Blue.
En la segunda View tenemos una calculadora para ver segun el monto en Peso Argentino cuanto da la conversión en Real de Brasil, Peso Chileno y Peso Uruguayo ademas de Dolar, todas esas monedas a su valor Blue.
Es una idea surgida para solucionar un problema que a veces tienen turistas cuando vienen a Argentina y se "marean" con las conversiones y los distintos valores de la moneda Argentina.
Tecnologias usadas:

UIKit
Arquitectura MVVM
UI Programatica
CollectionViews
SegmentedControls
Delegate Pattern
Request APIs
Local Push Notifications

## Requisitos de Inicialización

- Crea un archivo `Secrets.plist` con la clave `API_KEY` o define la variable de entorno `API_KEY` (ver `.env.example`).
- Configura Firebase y Google Sign-In añadiendo el `GoogleService-Info.plist` y los permisos necesarios.






