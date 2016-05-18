# PubMedFormatter

Generate pre-formatted html citation list form [PubMed](http://www.ncbi.nlm.nih.gov/pubmed) database using PubMed Unique Identifiers (PMID).

## Usage

```sh
./pubmedformatter input.pmid output
```

The `input.pmid` contains comma limited list of PMIDs without any extra spaces, e.g.
```
27126594,26905425,26596865,25411367,26063734,26415699,26395484,25492625,25174444,26708104,25708702,26198634,24116661,25074921,24616222,26103062,24630994,24569529,24632816,25273555,25157670,24136177,23876427,24006265,23843620,23375895,23447405,24110474,24262430,22302991,22119747,22096590,21081083,19949291,20807800,20711349
```

The output file `output` is created in two versions:
- `output` that contains plain text. References are formatted as *author, title, journal*
- `output.html` that contains html list of citations formatted as: *author, [title](http://www.ncbi.nlm.nih.gov/pubmed), journal*, where *title* points to that paper on [PubMed](http://www.ncbi.nlm.nih.gov/pubmed) page.