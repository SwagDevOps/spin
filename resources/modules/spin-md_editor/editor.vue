<script src="./script/editor.js"></script>

<template id="editor">
    <section class="is-md_editor">
        <b-tabs type="is-boxed" v-model="activeTab">
            <b-tab-item label="Edit" icon="file-document-edit-outline">
                <textarea :name="name"
                          :value="input"
                          ref="value"
                          @input="update">
                </textarea>
            </b-tab-item>
            <b-tab-item label="Preview" icon="eye">
                <div v-html="preview"
                     class="is-preview is-typographic"></div>
            </b-tab-item>
        </b-tabs>
    </section>
</template>
