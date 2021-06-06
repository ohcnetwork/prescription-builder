let str = React.string

open Webapi.Dom

let onWindowClick = (showDropdown, setShowDropdown, _event) =>
  if showDropdown {
    setShowDropdown(_ => false)
  } else {
    ()
  }

let toggleDropdown = (setShowDropdown, event) => {
  event |> ReactEvent.Mouse.stopPropagation
  setShowDropdown(showDropdown => !showDropdown)
}

let search = (searchString, selectables) =>
  (selectables |> Js.Array.filter(selection =>
    selection
    |> String.lowercase_ascii
    |> Js.String.includes(searchString |> String.lowercase_ascii) && selection != searchString
  ))->Belt.SortArray.stableSortBy((x, y) => String.compare(x, y))

let renderSelectables = (selections, updateCB) =>
  selections |> Array.mapi((index, selection) =>
    <button
      type_="button"
      key={index |> string_of_int}
      onClick={_ => updateCB(selection)}
      className="tw-w-full tw-block tw-px-4 tw-py-2 tw-text-sm tw-leading-5 tw-text-left tw-text-gray-700 hover:tw-bg-gray-100 hover:tw-text-gray-900 focus:tw-outline-none focus:tw-bg-gray-100 focus:tw-text-gray-900">
      {selection |> str}
    </button>
  )

let searchResult = (searchInput, updateCB, selectables) => {
  // Remove all excess space characters from the user input.
  let normalizedString =
    searchInput
    |> Js.String.trim
    |> Js.String.replaceByRe(Js.Re.fromStringWithFlags("\\s+", ~flags="g"), " ")
  switch normalizedString {
  | "" => []
  | searchString =>
    let matchingSelections = search(searchString, selectables)
    renderSelectables(matchingSelections, updateCB)
  }
}

let renderDropdown = results =>
  <div
    className="tw-origin-top-left tw-absolute tw-z-40 tw-left-0 tw-mt-2 tw-w-full tw-rounded-md tw-shadow-lg ">
    <div className="tw-rounded-md tw-bg-white tw-shadow-xs">
      <div className="tw-py-1 max-height-dropdown"> {results |> React.array} </div>
    </div>
  </div>

@react.component
let make = (~id, ~value, ~updateCB, ~placeholder, ~selectables) => {
  let results = searchResult(value, updateCB, selectables)
  let (showDropdown, setShowDropdown) = React.useState(_ => false)
  React.useEffect1(() => {
    let curriedFunction = onWindowClick(showDropdown, setShowDropdown)

    let removeEventListener = () => Window.removeEventListener("click", curriedFunction, window)

    if showDropdown {
      Window.addEventListener("click", curriedFunction, window)
      Some(removeEventListener)
    } else {
      removeEventListener()
      None
    }
  }, [showDropdown])

  <div className="tw-relative tw-inline-block tw-text-left tw-w-full">
    <input
      id
      value
      autoComplete="false"
      onClick={_ => setShowDropdown(_ => !showDropdown)}
      onChange={e => updateCB(ReactEvent.Form.target(e)["value"])}
      className="tw-appearance-none tw-h-10 tw-mt-1 tw-block tw-w-full tw-border tw-border-gray-400 tw-rounded tw-py-2 tw-px-4 tw-text-sm tw-bg-gray-100 hover:tw-bg-gray-200 focus:tw-outline-none focus:tw-bg-white focus:tw-border-gray-600"
      placeholder
      required=true
    />
    {results |> Array.length == 0
      ? switch showDropdown {
        | true => renderDropdown(renderSelectables(selectables, updateCB))
        | false => React.null
        }
      : switch showDropdown {
        | true => renderDropdown(results)
        | false => React.null
        }}
  </div>
}
