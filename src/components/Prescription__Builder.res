let str = React.string

let medicines = %bs.raw(`require("../assets/medicines.json")`)
let dosages = ["od", "hs", "bd", "tid", "qid", "q4h", "qod", "qwk", "sos"]
type prescriptions = array<Prescription__Prescription.t>

let findAndReplace = (index, f, array) =>
  array |> Array.mapi((i, prescription) => i == index ? f(prescription) : prescription)

type action =
  | UpdateMedicine(string, int)
  | UpdateDosage(string, int)
  | UpdateDays(int, int)
  | DeletePescription(int)
  | AddPescription

let reducer = (prescriptions, action) =>
  switch action {
  | UpdateMedicine(medicine, index) =>
    prescriptions |> findAndReplace(index, Prescription__Prescription.updateMedicine(medicine))

  | UpdateDosage(dosage, index) =>
    prescriptions |> findAndReplace(index, Prescription__Prescription.updateDosage(dosage))

  | UpdateDays(days, index) =>
    prescriptions |> findAndReplace(index, Prescription__Prescription.updateDays(days |> abs))

  | AddPescription => prescriptions |> Js.Array.concat([Prescription__Prescription.empty()])

  | DeletePescription(index) => prescriptions |> Js.Array.filteri((_, i) => i != index)
  }

let showPrescriptionForm = (item, index, send) =>
  <div className="tw-flex tw-justify-between tw-items-center" key={index |> string_of_int}>
    <div className="tw-m-1 tw-rounded-md tw-shadow-sm tw-w-4/6">
      <Prescription__Picker
        id={"medicine" ++ (index |> string_of_int)}
        value={item |> Prescription__Prescription.medicine}
        updateCB={medicine => send(UpdateMedicine(medicine, index))}
        placeholder="Select a Medicine"
        selectables=medicines
      />
    </div>
    <div className="tw-m-1 tw-rounded-md tw-shadow-sm tw-w-1/6">
      <Prescription__Picker
        id={"dosage" ++ (index |> string_of_int)}
        value={item |> Prescription__Prescription.dosage}
        updateCB={dosage => send(UpdateDosage(dosage, index))}
        placeholder="Dosage"
        selectables=dosages
      />
    </div>
    <div className="tw-m-1 tw-rounded-md tw-shadow-sm tw-w-1/6">
      <input
        id={"days" ++ (index |> string_of_int)}
        className="tw-appearance-none tw-h-10 tw-mt-1 tw-block tw-w-full tw-border tw-border-gray-400 tw-rounded tw-py-2 tw-px-4 tw-text-sm tw-bg-gray-100 hover:tw-bg-gray-200 focus:tw-outline-none focus:tw-bg-white focus:tw-border-gray-600"
        placeholder="Days"
        onChange={e => send(UpdateDays(ReactEvent.Form.target(e)["value"], index))}
        value={item |> Prescription__Prescription.days |> string_of_int}
        type_="number"
        required=true
      />
    </div>
    <div
      onClick={_ => send(DeletePescription(index))}
      className="tw-appearance-none tw-h-10 tw-mt-1 tw-block tw-border tw-border-gray-400 tw-rounded tw-py-2 tw-px-4 tw-text-sm tw-bg-gray-100 hover:tw-bg-gray-200 focus:tw-outline-none focus:tw-bg-white focus:tw-border-gray-600 tw-text-gray-600 tw-font-bold">
      {"x" |> str}
    </div>
  </div>

@react.component
let make = (~prescriptions, ~selectCB) => {
  let send = action => reducer(prescriptions, action) |> selectCB
  <div
    className="tw-bg-white tw-px-4 tw-py-5 tw-border-b tw-border-gray-200 sm:tw-px-6 tw-max-w-3xl tw-mx-auto tw-border tw-mt-4">
    <h3 className="tw-text-lg tw-leading-6 tw-font-medium tw-text-gray-900">
      {"Prescription" |> str}
    </h3>
    <div className="tw-flex tw-justify-between tw-mt-4">
      <div className="tw-m-1 tw-rounded-md tw-shadow-sm tw-w-4/6">
        <label
          htmlFor="Medicine"
          className="tw-block tw-text-sm tw-font-medium tw-leading-5 tw-text-gray-700">
          {"Medicine" |> str}
        </label>
      </div>
      <div className="tw-m-1 tw-rounded-md tw-shadow-sm tw-w-1/6">
        <label
          htmlFor="Dosage"
          className="tw-block tw-text-sm tw-font-medium tw-leading-5 tw-text-gray-700">
          {"Dosage" |> str}
        </label>
      </div>
      <div className="tw-m-1 tw-rounded-md tw-shadow-sm tw-w-1/6">
        <label
          htmlFor="Days"
          className="tw-block tw-text-sm tw-font-medium tw-leading-5 tw-text-gray-700">
          {"Days" |> str}
        </label>
      </div>
    </div>
    {prescriptions
    |> Array.mapi((index, item) => showPrescriptionForm(item, index, send))
    |> React.array}
    <div className="tw-m-1 tw-rounded-md tw-shadow-sm tw-bg-gray-200 tw-rounded">
      <button
        type_="button"
        onClick={_ => send(AddPescription)}
        className="tw-w-full tw-font-bold tw-block tw-px-4 tw-py-2 tw-text-sm tw-leading-5 tw-text-left tw-text-gray-700 hover:tw-bg-gray-100 hover:tw-text-gray-900 focus:tw-outline-none focus:tw-bg-gray-100 focus:tw-text-gray-900">
        {"+ Add medicine" |> str}
      </button>
    </div>
  </div>
}
