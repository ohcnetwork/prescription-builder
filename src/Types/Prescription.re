type t = {
  medicine: string,
  doasge: string,
  days: int,
};

let medicine = t => t.medicine;
let doasge = t => t.doasge;
let days = t => t.days;

let empty = () => {medicine: "", doasge: "", days: 0};

let updateMedicine = (medicine, t) => {...t, medicine};
