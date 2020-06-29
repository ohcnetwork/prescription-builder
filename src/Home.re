let str = React.string;

[@react.component]
let make = () => {
  let (prescriptions, setPrescriptions) = React.useState(_ => [||]);

  <Prescription__Builder prescriptions={prescriptions} selectCB={setPrescriptions}/>;
};
