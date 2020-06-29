let str = React.string;

let select = (setPrescription, prescription) => setPrescription(_ => prescription);

[@react.component]
let make = () => {
  let (prescriptions, setPrescriptions) = React.useState(_ => [||]);

  <Prescription__Builder prescriptions={prescriptions} selectCB={select(setPrescriptions)}/>;
};
