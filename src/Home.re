let str = React.string;
type prescriptions = array(Prescription.t);

[@react.component]
let make = () => {
  let (prescriptions, setPrescriptions) = React.useState(_ => [||]);

  <Prescription__Builder prescriptions={prescriptions} selectCB={setPrescriptions}/>;
};
