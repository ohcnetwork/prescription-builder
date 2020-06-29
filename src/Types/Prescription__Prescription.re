type t = {
  medicine: string,
  dosage: string,
  days: int,
};

let medicine = t => t.medicine;
let dosage = t => t.dosage;
let days = t => t.days;

let empty = () => {medicine: "", dosage: "", days: 0};

let updateMedicine = (medicine, t) => {...t, medicine};
let updateDosage = (dosage, t) => {...t, dosage};
let updateDays = (days, t) => {...t, days};
