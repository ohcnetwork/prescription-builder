let str = React.string;

type state = {
  prescriptions: array(Prescription.t),
  dirty: bool,
};

let findAndReplace = (index, f, array) => {
  array
  |> Array.mapi((i, prescription) => {
       i == index ? f(prescription) : prescription
     });
};

type action =
  | UpdateMedicine(string, int);

let reducer = (state, action) =>
  switch (action) {
  | UpdateMedicine(medicine, index) => {
      ...state,
      prescriptions:
        state.prescriptions
        |> findAndReplace(index, Prescription.updateMedicine(medicine)),
    }
  };

let showPrescriptionForm = (item, index, send) => {
  <div className="flex justify-between" key={index |> string_of_int}>
    <div className="m-1 rounded-md shadow-sm w-4/6">
      <MedicinePicker
        id="1"
        value={item |> Prescription.medicine}
        updateMedicineCB={medicine => send(UpdateMedicine(medicine, index))}
      />
    </div>
    <div className="m-1 rounded-md shadow-sm w-1/6">
      <input
        id="Dosage"
        className="appearance-none h-10 mt-1 block w-full border border-gray-400 rounded py-2 px-4 text-sm bg-gray-100 hover:bg-gray-200 focus:outline-none focus:bg-white focus:border-gray-600"
        placeholder="Dosage"
      />
    </div>
    <div className="m-1 rounded-md shadow-sm w-1/6">
      <input
        id="Days"
        className="appearance-none h-10 mt-1 block w-full border border-gray-400 rounded py-2 px-4 text-sm bg-gray-100 hover:bg-gray-200 focus:outline-none focus:bg-white focus:border-gray-600"
        placeholder="Days"
      />
    </div>
  </div>;
};

let initalState = () => {
  prescriptions: [|Prescription.empty()|],
  dirty: false,
};

[@react.component]
let make = () => {
  let (state, send) = React.useReducer(reducer, initalState());
  <div
    className="bg-white px-4 py-5 border-b border-gray-200 sm:px-6 max-w-3xl mx-auto border mt-4">
    <h3 className="text-lg leading-6 font-medium text-gray-900">
      {"Prescription" |> str}
    </h3>
    <div className="flex justify-between mt-4">
      <div className="m-1 rounded-md shadow-sm w-4/6">
        <label
          htmlFor="Medicine"
          className="block text-sm font-medium leading-5 text-gray-700">
          {"Medicine" |> str}
        </label>
      </div>
      <div className="m-1 rounded-md shadow-sm w-1/6">
        <label
          htmlFor="Dosage"
          className="block text-sm font-medium leading-5 text-gray-700">
          {"Dosage" |> str}
        </label>
      </div>
      <div className="m-1 rounded-md shadow-sm w-1/6">
        <label
          htmlFor="Days"
          className="block text-sm font-medium leading-5 text-gray-700">
          {"Days" |> str}
        </label>
      </div>
    </div>
    {state.prescriptions
     |> Array.mapi((index, item) => showPrescriptionForm(item, index, send))
     |> React.array}
  </div>;
};
