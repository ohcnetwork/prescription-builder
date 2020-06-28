let str = React.string;
let medicines = [%bs.raw {|require("../assets/medicines.json")|}];

let search = searchString =>
  (
    medicines
    |> Js.Array.filter(selection =>
         selection
         |> String.lowercase_ascii
         |> Js.String.includes(searchString |> String.lowercase_ascii)
         && selection != searchString
       )
  )
  ->Belt.SortArray.stableSortBy((x, y) => String.compare(x, y));

let searchResult = (searchInput, updateMedicineCB) => {
  // Remove all excess space characters from the user input.
  let normalizedString = {
    searchInput
    |> Js.String.trim
    |> Js.String.replaceByRe(
         Js.Re.fromStringWithFlags("\\s+", ~flags="g"),
         " ",
       );
  };

  switch (normalizedString) {
  | "" => [||]
  | searchString =>
    let matchingSelections = search(searchString);

    matchingSelections
    |> Array.mapi((index, selection) =>
         <button
           key={index |> string_of_int}
           onClick={_ => updateMedicineCB(selection)}
           className="block px-4 py-2 text-sm leading-5 text-left text-gray-700 hover:bg-gray-100 hover:text-gray-900 focus:outline-none focus:bg-gray-100 focus:text-gray-900">
           {selection |> str}
         </button>
       );
  };
};

[@react.component]
let make = (~id, ~value, ~updateMedicineCB) => {
  let (state, setState) = React.useState(() => []);
  let results = searchResult(value, updateMedicineCB);
  <div className="relative inline-block text-left w-full">
    <input
      id
      value
      autoComplete="false"
      onChange={e => updateMedicineCB(ReactEvent.Form.target(e)##value)}
      className="appearance-none h-10 mt-1 block w-full border border-gray-400 rounded py-2 px-4 text-sm bg-gray-100 hover:bg-gray-200 focus:outline-none focus:bg-white focus:border-gray-600"
      placeholder="Select a medcicine"
    />
    {results |> Array.length == 0
       ? React.null
       : <div
           className="origin-top-left absolute z-40 left-0 mt-2 w-full rounded-md shadow-lg ">
           <div className="rounded-md bg-white shadow-xs">
             <div className="py-1 max-height-dropdown">
               {searchResult(value, updateMedicineCB) |> React.array}
             </div>
           </div>
         </div>}
  </div>;
};
