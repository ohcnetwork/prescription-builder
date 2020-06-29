type t = {
  medicine: string,
  dosage: string,
  days: int,
};

let medicine = t => t.medicine;
let dosage = t => t.dosage;
let days = t => t.days;

let make = 
    (
      medicine,
      dosage,
      days
    ) => {
  medicine,
  dosage,
  days
};

let empty = () => {medicine: "", dosage: "", days: 0};

let updateMedicine = (medicine, t) => {...t, medicine};
let updateDosage = (dosage, t) => {...t, dosage};
let updateDays = (days, t) => {...t, days};

let decode = json =>
  Json.Decode.{
    medicine: json |> field("medicine", string),
    dosage: json |> field("dosage", string),
    days: json |> field("days", int),
  };

let encode = t =>
  Json.Encode.(
    object_([
      ("medicine", t.medicine |> string),
      ("dosage", t.dosage |> string),
      ("days", t.days |> int),
    ])
  );

let encodeArray = prescriptions => prescriptions |> Json.Encode.(array(encode));