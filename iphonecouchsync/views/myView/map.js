function(doc) {
    if (doc.name && doc.description) {
        emit(doc.name, doc);
    }
}