let str = React.string;
type prescriptions = array(Prescription.t);

[@react.component]
let make = () => {
  let (prescriptions, setPrescriptions) = React.useState(_ => [||]);

  <Builder prescriptions={prescriptions} selectCB={setPrescriptions}/>;
};
